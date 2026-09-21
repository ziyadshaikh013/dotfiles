---
name: levo-bugs
description: Sync bug reports from the #levo-bug-report Slack channel into a daily Obsidian note. Use when user says "/levo-bugs" or "sync bugs" or "update bug list". The agent decides what to add, close, or update based on Slack thread status.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: slack-sync
---

# Levo Bugs Sync

You are triaging bug reports from Slack into the Obsidian vault. Follow these steps in order.

## Configuration

| Key | Value |
|---|---|
| Channel ID | `C05ARG5U8UD` |
| Channel Name | `levo-bug-report` |
| My Slack User ID | `U01H3QRD63E` |
| Vault Root | `/home/ziyad/Documents/Obsidian/Cerebrum` |
| Bugs Dir | `/home/ziyad/Documents/Obsidian/Cerebrum/The Internet Folks/Levo Bugs` |
| Attachments Dir | `/home/ziyad/Documents/Obsidian/Cerebrum/The Internet Folks/Levo Bugs/attachments` |
| Index File | `/home/ziyad/Documents/Obsidian/Cerebrum/The Internet Folks/Levo Bugs/_index.md` |

> **IMPORTANT:** Always use the absolute paths above regardless of the current working directory. This ensures the vault is updated correctly even if the skill is run from outside the vault.

## Index File

The `_index.md` file is the single source of truth for deduplication. It tracks every bug ever recorded using only the Slack message timestamp as the unique key. The format is:

```markdown
---
updated: DD MMM, YYYY
---

- 1775216101.211519
- 1775887278.765169
- 1777361861.210229
```

Each line is just the Slack TS of a bug message that has been recorded. If a TS exists in this list, the bug is already tracked and must be skipped.

After recording new bugs, append their TS values to this list and update the `updated` frontmatter date.

## Scan Range

The scan range determines how far back to look for bug messages. Use `recent` by default — only switch to `all` if the user explicitly says "scan all" or "full scan".

| Option | Description |
|---|---|
| `recent` | **Default.** Only scan bugs from yesterday and today. Use this for daily check-ins. |
| `all` | Scan all bugs from the pinned summary + all channel messages. Use only when the user explicitly requests it, or for a first-time sync. |

## Step 1 — Determine today's document

1. Get today's date in `DD MMM, YYYY` format (e.g. `16 May, 2026`).
2. Check if a file named `DD MMM, YYYY.md` exists in the Bugs Dir (e.g. `16 May, 2026.md`).
3. If it exists → read it and proceed to merge updates into it.
4. If it does not exist → create a new document from scratch using the template below.

**New document template:**

```markdown
---
created: DD MMM, YYYY
source: "#levo-bug-report"
status: pending
---

# Bug Report — DD MMM, YYYY

> [!info] Source
> Pinned message in [#levo-bug-report](https://the-internet-folks.slack.com/archives/C05ARG5U8UD/p1778560393217239)

---

```

## Step 2 — Read the index

1. Read `{Bugs Dir}/_index.md`.
2. If it doesn't exist → create it with the template below and start fresh.
3. Collect all Slack TS values from the list — these are bugs that have **already been recorded** and must not be duplicated.

**Index template (for a new file):**

```markdown
---
updated: DD MMM, YYYY
---

```

Any Slack TS found in this list will be **skipped** in later steps to prevent duplicates.

## Step 3 — Fetch pinned summary

1. Use Composio (`SLACK_LIST_PINNED_ITEMS`) on channel `C05ARG5U8UD`.
2. Find the pinned message that mentions `<@U01H3QRD63E>` — this is the bug summary list.
3. Use `SLACK_FETCH_MESSAGE_THREAD_FROM_A_CONVERSATION` with `channel=C05ARG5U8UD` and the `thread_ts` of that pinned message to get all replies.
4. Extract each bug line (bullet items) that references your user ID. Each line contains a title and one or more Slack message links.

## Step 4 — Fetch each bug message

For every Slack message URL found in the summary, and depending on the scan range:

- **`recent`** — only fetch messages from yesterday and today (use `oldest` = start of yesterday in epoch seconds).
- **`all`** — fetch all messages from the summary plus any new messages in the channel.

For each message:

1. Parse the channel ID and message timestamp from the URL (format: `/archives/{channel}/{timestamp}`). The timestamp in URLs uses `p` prefix instead of dots — convert `p1778574554602859` → `1778574554.602859` (insert dot after the 10th digit).
2. **Check index** — if this Slack TS already exists in `_index.md`, skip it entirely (already tracked in a previous day's document).
3. Use `SLACK_FETCH_CONVERSATION_HISTORY` with `channel`, `oldest`/`latest` around that timestamp, and `inclusive=true` to fetch the original message.
4. Save the message text, author, files, and thread replies.

## Step 5 — Check thread status (open vs closed)

For each new bug message, fetch its thread replies using `SLACK_FETCH_MESSAGE_THREAD_FROM_A_CONVERSATION`:

- **Closed** = your user (`U01H3QRD63E`) posted a reply containing "Already fix and deployed" (or similar phrasing like "fixed", "deployed", "resolved").
- **Open** = no such reply from you exists, or the last reply is from someone else asking for updates.

Also re-check previously recorded bugs in today's document — if a thread that was open is now closed, update it.

## Step 6 — Read existing document

Read today's document from the vault (created in Step 1 if new). Note which bugs already exist (match by Slack URL) and their checkbox status (`[ ]` open, `[x]` closed).

## Step 7 — Decide actions

Compare Slack data against the index and today's document:

| Situation | Action |
|---|---|
| Bug TS already in `_index.md` | **Skip** — duplicate, already tracked in a previous day's document |
| Bug TS already in **today's** document, status matches | **Skip** — already up to date |
| Bug TS already in **today's** document as `[ ]` but thread is now closed | **Close** — mark checkboxes `[x]`, add `✅ Closed` note, update index status to `closed` |
| Bug TS already in **today's** document as `[x]` but thread has new activity | **Update** — add any new details from recent replies |
| Bug TS NOT in index or any document (new bug) | **Add** — create a new `## N.` section, add row to `_index.md` with status `open` |

When adding a new bug:
- Download any image/file attachments using `SLACK_DOWNLOAD_SLACK_FILE`, save to the Attachments Dir with a descriptive filename (e.g. `bug12-description.png`).
- Reference attachments using Obsidian embed syntax: `![[attachments/filename.png]]`
- Clean up Slack user mentions (`<@U...>`) — resolve to real names if possible or remove them.
- Clean up Slack formatting (convert `*bold*` to `**bold**`, etc.).

## Step 8 — Apply changes

1. Write the updated document back to the vault at `{Bugs Dir}/{DD MMM, YYYY}.md`. Keep the existing frontmatter structure but update the `status` field:
   - `pending` if any bugs are still open
   - `complete` if all bugs are closed
2. Update `_index.md` — add new bug rows, update statuses for closed bugs, and set `updated` in frontmatter to today's date.

## Step 9 — Summarize

Report back to the user with a concise summary:
- Scan range used (`recent` or `all`)
- How many new bugs added
- How many bugs closed
- How many unchanged
- How many duplicates skipped
- Any bugs that need attention (e.g., thread has new unread replies)