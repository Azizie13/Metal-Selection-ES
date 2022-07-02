import tkinter as tk


class SelectionFrame:
    def __init__(self, parent, prompt="", default="", selections=None):
        self.popup = tk.Toplevel(parent)
        self.popup.title(prompt)
        self.popup.transient(parent)
        self.selections = selections if selections else []

        frame = tk.LabelFrame(self.popup, text=default, padx=0, pady=0)
        frame.pack(padx=50, pady=50)

        label = tk.Label(frame, text=prompt)
        buttons = tk.Frame(frame)

        buttons.pack(side="bottom", fill="x")
        label.pack(side="top", fill="x", padx=20, pady=10)

        self.option = tk.StringVar(value=selections[0])
        for selection in self.selections:
            tk.Radiobutton(
                buttons, text=selection, variable=self.option, value=selection
            ).pack(anchor="w")

        submit = tk.Button(buttons, text="Submit", command=self.popup.destroy)
        submit.pack(side="top")

    def show(self):
        self.popup.wait_window(self.popup)
        return self.option.get()


class EntryFrame:
    def __init__(self, parent, prompt="", default=""):
        self.popup = tk.Toplevel(parent)
        self.popup.title(prompt)
        self.popup.transient(parent)
        self.selection = tk.StringVar()
        self.label = None

        frame = tk.LabelFrame(self.popup, text=default, padx=0, pady=0)
        frame.pack(padx=50, pady=50)

        label = tk.Label(frame, text=prompt)
        frame_entry = tk.Frame(frame)

        frame_entry.pack(side="bottom", fill="x")
        label.pack(side="top", fill="x", padx=20, pady=10)
        self.entry = tk.Entry(
            frame_entry, width=35, borderwidth=5, textvariable=self.selection
        )
        self.entry.pack(side="top", fill="x", padx=20, pady=10)

        submit = tk.Button(frame, text="Submit", command=self.popup.destroy)
        submit.pack(side="top")

    def show(self):
        self.popup.wait_window(self.popup)
        return self.selection.get()


def ask_question(root, prompt, selections):
    dialog = SelectionFrame(
        root,
        prompt=prompt,
        selections=selections,
    )
    return dialog.show()


def ask_entry(root, prompt):
    dialog = EntryFrame(root, prompt=prompt)
    return dialog.show()
