# KOReader.patches
Patches for KOReader

## [2-ignore-non-books-stats](2-ignore-non-books-stats.lua)

Ignores all books not being in `/mnt/onboard/.koreader/Books`.
It disables:
- Reading Stats
- Book History

It also disables creating settings for files which aren't in `/mnt/onboard/.koreader`.

The code was mostly copied from [here](https://github.com/koreader/koreader/issues/10308#issuecomment-1507743114)

## [2-reading-stats-book-total-percent](2-reading-stats-book-total-percent.lua)

Shows the full percentage up to which point the book was read in Reading Stats > {Book} > Days reading this book.

E.g.: `2026-02-16   00:13:37 (42 pages) -> 13,37%`

I used [this patch](https://github.com/omer-faruq/koreader-user-patches/blob/main/2-reading-stats-current-book-days-percent.lua) as a starter.
