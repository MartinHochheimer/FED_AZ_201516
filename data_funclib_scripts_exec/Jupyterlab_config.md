# Code snippets for customising jupyterlab (calling lab new from inside the docker each time ...tricky^^)

# shortcut for running selections of code in qtconsole
    // List of Keyboard Shortcuts
    "shortcuts": [
        {
            "command": "notebook:run-in-console",
            "keys": [
                "F9"
            ],
            "selector": ".jp-Notebook.jp-mod-editMode"
        },
    ]