#!/usr/bin/env node
// SessionStart hook — notify the user when a newer plugin version is published.
// Fail-silent by design: a version check must never block or break a session.
//
// Self-locates via __dirname (does NOT rely on CLAUDE_PLUGIN_ROOT being exported
// into the process env, which is unreliable for SessionStart hooks).
// Set FDP_NO_UPDATE_CHECK=1 to disable.

'use strict';

if (process.env.FDP_NO_UPDATE_CHECK) process.exit(0);

const fs = require('fs');
const os = require('os');
const path = require('path');
const https = require('https');

const REMOTE_URL =
  'https://raw.githubusercontent.com/leee880619-commits/frontend-designer-pro/main/.claude-plugin/plugin.json';
const CHECK_INTERVAL_MS = 6 * 60 * 60 * 1000; // hit the network at most once per 6h
const NET_TIMEOUT_MS = 2500;
const CACHE_FILE = path.join(os.tmpdir(), 'frontend-designer-pro.update-check.json');

function emit(message, local, latest) {
  if (message) {
    process.stdout.write(
      JSON.stringify({
        systemMessage: message,
        hookSpecificOutput: {
          hookEventName: 'SessionStart',
          additionalContext:
            `frontend-designer-pro update available: installed ${local}, latest ${latest}. ` +
            `If the user has not noticed, tell them they can update via the /plugin menu.`,
        },
      })
    );
  }
  process.exit(0);
}

function readLocalVersion() {
  try {
    const p = path.join(__dirname, '..', '.claude-plugin', 'plugin.json');
    return JSON.parse(fs.readFileSync(p, 'utf8')).version || null;
  } catch {
    return null;
  }
}

function readCache() {
  try {
    return JSON.parse(fs.readFileSync(CACHE_FILE, 'utf8'));
  } catch {
    return null;
  }
}

function writeCache(obj) {
  try {
    fs.writeFileSync(CACHE_FILE, JSON.stringify(obj));
  } catch {
    /* ignore — cache is best-effort */
  }
}

// Compare dotted numeric versions ("1.2.0"). Returns true if a > b.
function isNewer(a, b) {
  const pa = String(a).split('.').map((n) => parseInt(n, 10) || 0);
  const pb = String(b).split('.').map((n) => parseInt(n, 10) || 0);
  const len = Math.max(pa.length, pb.length);
  for (let i = 0; i < len; i++) {
    const da = pa[i] || 0;
    const db = pb[i] || 0;
    if (da > db) return true;
    if (da < db) return false;
  }
  return false;
}

function notify(local, latest) {
  if (latest && local && isNewer(latest, local)) {
    emit(
      `🎨 frontend-designer-pro 새 버전 ${latest}이(가) 있습니다 (현재 ${local}). ` +
        `/plugin 메뉴에서 업데이트하세요.`,
      local,
      latest
    );
  }
  emit(null);
}

function fetchRemoteVersion(cb) {
  let settled = false;
  const finish = (v) => {
    if (settled) return;
    settled = true;
    cb(v);
  };
  try {
    const req = https.get(REMOTE_URL, { timeout: NET_TIMEOUT_MS }, (res) => {
      if (res.statusCode !== 200) {
        res.resume();
        return finish(null);
      }
      let data = '';
      res.on('data', (c) => (data += c));
      res.on('end', () => {
        try {
          finish(JSON.parse(data).version || null);
        } catch {
          finish(null);
        }
      });
    });
    req.on('timeout', () => req.destroy());
    req.on('error', () => finish(null));
  } catch {
    finish(null);
  }
}

const local = readLocalVersion();
if (!local) emit(null); // can't determine local version -> stay silent

const cache = readCache();
const now = Date.now();

if (cache && cache.latest && now - (cache.ts || 0) < CHECK_INTERVAL_MS) {
  // Network check is still fresh: reuse cached latest, but re-evaluate against the
  // CURRENT local version so the notice disappears the moment the user updates.
  notify(local, cache.latest);
} else {
  fetchRemoteVersion((latest) => {
    if (latest) writeCache({ ts: now, latest });
    notify(local, latest || (cache && cache.latest) || local);
  });
}
