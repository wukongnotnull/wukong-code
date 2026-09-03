const { test } = require('node:test');
const assert = require('node:assert/strict');
const { wrapInFrame } = require('../../skills/brainstorming/scripts/server.cjs');

test('wrapInFrame inserts $&, $\', and $$ fragment text without replacement tokens', () => {
  const fragment = '<p>use $& and $\' and $$ here</p>';
  const html = wrapInFrame(fragment);
  assert.match(html, /<div class="header">/);
  assert.doesNotMatch(html, /<!-- CONTENT -->/);
  assert.equal(html.includes(fragment), true);
  assert.equal(html.includes('use <!-- CONTENT -->'), false);
});
