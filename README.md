# Project - *Syncify*

Submitted by: **Salma Mohammad**

**Syncify** is a turn-based playlist game where two friends swipe on songs they like or dislike, and the app builds a collaborative Spotify playlist from the mutual likes.  

Time spent: **12** hours spent in total

## Functions currently implemented

- [x] User can swipe left or right on songs to indicate dislike/like  
- [x] Liked songs are stored in a match list (via `GameManager.matches`)  
- [x] Game ends when all songs have been swiped (basic alert for now)  
- [ ] Result screen displays mutual liked songs  
- [ ] Button on results screen generates a Spotify playlist (mock or real API)  
- [ ] App uses a tab bar with:
    - Game tab
    - History tab to store/view past generated playlists
- [x] **Song images load dynamically from URLs** (falls back to a placeholder)  
- [x] **Placeholder images for missing album art** (`UIImage(systemName: "music.note")`)

## Features planned for the **future**

- [ ] Custom swipe animations for cards (like/nah badges, improved rotation)  
- [ ] Persist history using `UserDefaults` (store created playlist links)  
- [ ] Dark mode polish & testing (uses system colors already, but needs QA)  
- [ ] Results screen UI (table of matches + stats)  
- [ ] “Create Playlist” flow (mock first, then real Spotify API)  
- [ ] Tab Bar with Game + History tabs and basic persisted history  

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Demo](https://github.com/SalmaM04/syncify/blob/main/demo.gif?raw=true)

## Notes

Describe any challenges encountered while building the app:
- Image URLs returning `404` and how mock placeholders were used
- Planning UI structure before API integration

## License

    Copyright [2025] [Your Name]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0
