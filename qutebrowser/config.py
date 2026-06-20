def get_creds(path, default):
    import pathlib
    try:
        p = pathlib.Path(path).expanduser()
        with open(p) as f:
            creds = f.read()
        return creds.rstrip()
    except:
        return default

def rutorrent():
        return get_creds("~/.rutorrent", "burmudar:EMPTY")

def kagi_search():
    token = get_creds("~/.kagi", "")
    params = ["q={}"]
    if token != "":
        params.insert(0, f"token={token}")
    return f"https://kagi.com/search?{'&'.join(params)}"

KAGI_SEARCH = kagi_search()
SEARCH = "https://www.perplexity.ai/search/?q={}"

config.load_autoconfig()

# stop closing things by mistake
config.unbind('d', mode='normal')
config.bind(',d', 'tab-close')
c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True

c.url.default_page = KAGI_SEARCH
c.url.start_pages = ["https://github.com"]
c.tabs.favicons.scale = 1.0
c.tabs.width = 250
c.tabs.padding = {"bottom": 5, "left": 5, "right": 5, "top": 5}
c.tabs.position = "right"
c.tabs.title.format = "{index}.{current_title}"
# when the tab is selected make it more visible
c.fonts.tabs.selected = '14pt default_family'
c.fonts.tabs.unselected = '10pt default_family'
c.content.local_content_can_access_remote_urls
c.url.searchengines = {
            "DEFAULT": SEARCH,
            "p": SEARCH,
            "s": "https://sourcegraph.sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "ss": "https://sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "g": "https://google.com/search?q={}",
            "gif": "https://giphy.com/search/{}",
            "n": "https://search.nixos.org/packages?query={}",
         }

c.aliases["okta"] = "config-cycle content.local_content_can_access_remote_urls false true"

config.bind(',1', "open https://mail.google.com")
config.bind(',2', "open https://calendar.google.com")
config.bind(',3', "open https://github.com")
config.bind(',4', "open https://sourcegraph.sourcegraph.com")
config.bind(',5', "open https://sourcegraph.com")
config.bind(',6', "open https://sourcegraph.test:3443")
config.bind(',7', f"open https://{rutorrent()}@leon.feralhosting.com/burmudar/rutorrent/")
config.bind('tt', 'set-cmd-text -s :tab-select')
config.bind(',s', 'set-cmd-text :open https://github.com/sourcegraph/')
