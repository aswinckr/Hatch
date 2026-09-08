# Instructor materials

Read the [research decisions](RESEARCH-NOTES.md), [teacher guide](TEACHER-GUIDE.md), [full-day schedule](RUN-OF-SHOW.md), and [evaluation record](EVALUATION.md). The instructor PPTX contains private presenter notes; the participant deck and PDF omit those notes. The published teacher guide is readable by repository members.

## Finished demo and rehearsal outputs

[instructor-materials.zip.enc](instructor-materials.zip.enc) contains the full original/practice/comparison app, answer map, the completed warmup page, actual HTML reports from all three skill versions, matched test screenshots, and a clean control report. Keep this material out of audit environments. This package preserves the finished demo while the participant ZIP contains only the exercise site.

The decryption key is deliberately local, outside GitHub. Aswin can find it alongside the original project backup under `Hatch Backups/2026-09-08_21-41-06_before-workshop-preparation/instructor-pack.key`.

With OpenSSL available, run this in an instructor-only folder, replacing the key path with its actual location:

```sh
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in instructor-materials.zip.enc -out instructor-materials.zip \
  -pass 'file:/absolute/path/to/instructor-pack.key'
```

Extract the ZIP. In `instructor-app`, run `npm ci` then `npm run dev`. Open `/` for the original, `/practice` for the intentionally imperfect app, and `/compare` for the explanation. The finished warmup is `warmup-completed/index.html`. Open rehearsal HTML files directly in a browser; their evidence is embedded. Reports are frozen test outputs and deliberately include their original limitations.

The encryption is a practical distribution barrier, not a substitute for audit isolation. The historical Git repository contains previous app/answer files. Do not give an unrestricted audit agent the full checkout or key.

## Recovery

A verified full project backup includes the original Git index, staged/unstaged work, all untracked files, original deck PPTX/PDF, and a current editable Figma `.fig` backup. Existing local work was preserved; publication uses an isolated Git worktree. [Figma organization record](FIGMA-ORGANIZATION.md) · [Publication and local checkout details](DELIVERY.md).
