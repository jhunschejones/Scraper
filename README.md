# Scraper

[![CI](https://github.com/jhunschejones/Scraper/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jhunschejones/Scraper/actions/workflows/ci.yml)

Scraper is a Ruby script that uses `selenium-webdriver` to load an Amazon book details page and programmatically generate a list of book titles and authors that readers of the target book have also read or bought.

## Using The Script

### Installation
To use the script through the CLI, you will need to install the required Ruby dependencies and download the [`chromedriver`](https://chromedriver.chromium.org/downloads) binary version that matches your local Chrome version. (This will go in the `bin/` directory of this project.)

To help streamline the setup process, Scraper project includes a script that will attempt to install `homebrew`, `rbenv`, `ruby`, and `chromedriver`, along with the required Ruby dependencies. To use the install script, simply run `./bin/install` in the terminal from the root of the project directory. If you get a 'permission denied' error, you can make all the `bin/` files executable with the command `chmod +x ./bin/*`.

### In Use
Once you have completed the install steps above, you can simply run `./bin/run` in the terminal from the root of the project to start the script. You will see some information and a prompt to enter a comma-separated list of Amazon urls to scrape. Allow the automated browser to run on its own for each URL. After each scraper run, the results will be saved to a new file in the `csv/` directory named with the target book name and a timestamp for the run. When the script has processed all the requested urls, it will open the `csv/` directory in Finder for easy access.

If the script fails partway through, you can look at the `./tmp/log.txt` file to see what the last successfully scraped URL was. Attempt to run the script again, pasting in the remaining URLs. If the failure persists, the script may have to be modified before proceeding.

The script has been updated to run in headless mode, but if you want to still watch the browser you can run it with `SHOW_BROWSER=true ./bin/run`.

### Cleanup
After you have saved or otherwise captured the exported data, you can use the `./bin/clean` script to remove the generated CSV files and logs between script runs.

## Testing
Scraper includes a rudimentary, `Test::Unit`-based test suite. Some of the tests scrape real Amazon URLs in order to test under realistic circumstances. To run the test suite, preform the setup steps above and then run `./bin/test` in the terminal. Note that the realtime web scraping tests will take longer to run as they actually boot up the entire `chromedriver` binary, just like the script does when in use.
