import tkinter as tk
import logging
import clips
from frames import SelectionFrame, EntryFrame
from es_interface import ESInterface


logging.basicConfig(
    level=logging.DEBUG,
    filename="debug.log",
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)


CLIPS_IN_FILE = "full_metal_selection v2.clp"


def main():
    env = clips.Environment()
    logging.info("CLIPS DOS detected")

    interface = ESInterface(env)

    env.define_function(interface.set_message_box, name="message")
    env.define_function(interface.set_buffer, name="buffer")

    env.load(CLIPS_IN_FILE)

    env.reset()

    logging.info("Initializing GUI")
    init_gui(env, interface)


def run_clips(env, interface):  # Function activate when button is pressed
    if interface.reset:
        interface.reset = False
        env.reset()

    logging.info("Running CLIPS")
    env.run()
    output = interface.check_buffer()
    finished = interface.check(output)

    logging.debug(f"output file read : {output}")
    logging.debug(f"is-program-finished : {finished}")

    if finished:
        logging.info("Done... program")
        logging.debug(f"Facts in working memory: {interface.get_facts()}")


def init_gui(env, interface):
    root = tk.Tk()
    root.title("Metal Selection Expert System")

    frame = tk.LabelFrame(root, text="", padx=0, pady=0)
    frame.pack(padx=100, pady=10)

    tk.Label(
        frame,
        text="Welcome to Car Chassis Material Selection Expert System. \nPlease select the options available.",
    ).pack()

    tk.Button(
        frame, text="Run the program cycle", command=lambda: run_clips(env, interface)
    ).pack()

    tk.Button(
        frame,
        text="Quit",
        command=root.destroy,
    ).pack()

    interface.set_gui_root(root)
    root.mainloop()


if __name__ == "__main__":
    main()
