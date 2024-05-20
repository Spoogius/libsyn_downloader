# libsyn_downloader
BASH script to mass download podcast from libsyn hosted sites

## Usage

First create file containing a complete list of links of all the episodes desired.

For all episodes of a show do the following. ([Procedure taken from BioSchokoMuffin's comment here](https://www.reddit.com/r/DataHoarder/comments/d6fp8q/scraping_links_from_libsyn/))

1) Navigate to the main podcast page, e.g. https://talkmusictalk.libsyn.com/
2) Scroll down until every episode you want to download is listed.
3) Press F12 to open the browser console and paste this:\
  ```console.log([...document.querySelectorAll("h2 > a.read_more")].map(x => x.href).join("\n"))```
4) Copy the console output to a file with no leading or trailing empty lines
5) Save and close the file

Next run the script on any linux machine by passing the episode list file to `script.sh`.\
```./script.sh <filename>```

You may need to give run permissions to the script by running `chmod +x script.sh`.

By default the mp3 files for the episodes will be sorted in a new folder called `podcasts/`. Each episode will have a the air date in the format %Y%m%d appended to the front of the filename for sorting purposes.
The output folder can be editing the first line of `script.sh`.

libsyn should really just add a download all button.
