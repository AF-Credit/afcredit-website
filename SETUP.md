# Working on this site from two PCs

## Why the repo moved out of OneDrive

OneDrive was syncing the `.git` folder between both machines. Git is not
designed for that — two machines writing to the same `.git` through a file
sync service corrupts the object store. Symptom: `fatal: mmap failed:
Invalid argument` and `git fetch` silently failing, which is how one PC ended
up ~15 commits behind without realising.

**GitHub is the sync mechanism. OneDrive must not touch the repo.**

## Location on each PC

    C:\Users\harry\dev\afcredit-website

Not in OneDrive, not on the Desktop.

## First-time setup on the second PC

    mkdir C:\Users\harry\dev
    cd C:\Users\harry\dev
    git clone https://github.com/AF-Credit/afcredit-website.git
    cd afcredit-website
    git config user.name "Harry Baker"
    git config user.email "harry@auracapital.co.uk"

## Daily routine — do this every time

Before you start work:

    git pull

After you finish a change:

    git add -A
    git commit -m "what you changed"
    git push

If you forget to pull first and the push is rejected:

    git pull --rebase
    git push

## The old OneDrive folder

`C:\Users\harry\OneDrive\Desktop\AF Credit Website` is now stale and its Git
state is broken. Everything in it has been pushed to GitHub already. Once you
have confirmed the new location works on both PCs, delete the old folder so
nobody edits the wrong copy by mistake.

## Previewing locally

The site uses root-relative links, so opening index.html directly will not work.
Serve it instead — for example:

    npx serve .

then open http://localhost:3000/
