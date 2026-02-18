# KOReader.patches
Patches for KOReader

## [2-ignore-non-books-stats](2-ignore-non-books-stats.lua)

Ignores all books not being in `/mnt/onboard/.koreader/Books`.
It disables:
- Reading Stats
- Book History

It also disables creating settings for files which aren't in `/mnt/onboard/.koreader`.

The code was mostly copied from [here](https://github.com/koreader/koreader/issues/10308#issuecomment-1507743114)

## [2-pt-modify-cached-cover-size](2-pt-modify-cached-cover-size.lua)

This patch allows you to modify the size of covers cached by Project Title.  
You can decrease the size to save disk space or increase it when using with other plugins or patches which are displaying the images large.

By default this patch changes the size to 750 (from 600). 750 worked fine on my device.  
You can modify `max_cover_dimension` if you prefer another size.

**Warning: Setting the size too big produces performance issues in Project Title.**
Make sure to disable this patch and recreate all metadata before creating an issue for Project Title.

This requires Project Title v3.7+

## [2-pt-progressbar-and-percentage](2-pt-progressbar-and-percentage.lua)

Shows the read percentage as well as the progress bar.
Only when the book is currently being read or paused.

You can configure it to show the percentage in a new line by setting `show_with_state = false`.  
You can enable set `percentage_decimal_places` to show a more precise percentage. (This is only applied with enabled progress bar)

![](resources/pt-state-percentage.png)

This requires Project Title v3.7+

## [2-pt-progressbar-koboclara-full](2-pt-progressbar-koboclara-full.lua)

Increases the Project Title progress bar to fill the whole available space on a Kobo Clara.
Use it with 5 items per page. (6 items is also fine but won't fill the whole screen.)

This is just a modified version of [this user patch](https://github.com/loeffner/KOReader.patches/blob/main/project-title/2-pt-modify-progressbar-max-width.lua) configured for my use-case.

## [2-pt-titlebar-collections](2-pt-titlebar-collections.lua)

Replaces the "Open last document" titlebar item with a shortcut to collections.  
On hold it will still open the last document.

## [2-reading-stats-book-total-percent](2-reading-stats-book-total-percent.lua)

Shows the full percentage up to which point the book was read in Reading Stats > {Book} > Days reading this book.

E.g.: `2026-02-16   00:13:37 (42 pages) -> 13,37%`

I used [this patch](https://github.com/omer-faruq/koreader-user-patches/blob/main/2-reading-stats-current-book-days-percent.lua) as a starter.
