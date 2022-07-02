import tkinter as tk
from frames import ask_question, ask_entry
import logging

logging.basicConfig(
    level=logging.DEBUG,
    filename="debug.log",
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)


class ESInterface:
    def __init__(self, env):
        self.env = env
        self.root = None
        self.label = None
        self.buffer: str
        self.reset: bool = False

    def check(self, output):

        default = "error"
        self.work_mem_button["state"] = (
            tk.NORMAL if self.work_mem_button["state"] == tk.DISABLED else tk.NORMAL
        )

        if isinstance(output, list):
            return getattr(self, "case_" + output[0])(output[1], output[2])

        return getattr(self, "case_" + output, lambda: default)()

    def set_gui_root(self, root):
        self.root = root

        frame = tk.LabelFrame(self.root, text="Info: ", padx=0, pady=0)
        frame.pack(padx=0, pady=0)

        self.work_mem_button = tk.Button(
            frame,
            text="Show working memory",
            command=lambda: print(
                "Facts in working memory:\n",
                "\n".join(map(str, self.get_facts())),
                "\n\n",
                sep="",
            ),
        )

        self.label = tk.Label(frame, text="Press run program cycle to start.")
        self.label.pack(padx=150, pady=10)

        self.work_mem_button.pack(padx=150, pady=10)
        self.work_mem_button["state"] = tk.DISABLED

    def get_facts(self):
        return list(fact for fact in self.env.facts())

    def case_error(self):
        logging.WARNING("The buffer got an unknown value.")

    def case_chassis_select(self):

        # Pop up gui here
        selection = ask_question(
            self.root, "Choose the desired car part:", ["front", "rear"]
        )
        self.env.assert_string(f"(chassis-type {selection})")

        logging.info("Display chassis-select screen")
        logging.info(f"You selected {selection} chassis")
        logging.debug(f"Facts in working memory: {self.get_facts()}")

        self.set_message_box(f"{selection.capitalize()} chassis selected.")

        return False

    def case_front_sol_select(self):
        logging.info("Display solution-select screen")

        # Pop up gui here
        selection = ask_question(
            self.root, "Choose the desired solution:", ["1", "2", "3", "4"]
        )
        self.env.assert_string(f"(solution-type {selection})")

        logging.info(f"You selected solution {selection}")
        logging.debug(f"Facts in working memory: {self.get_facts()}")

        self.set_message_box(f"Solution {selection} selected.")

        return False

    def case_rear_sol_select(self):
        logging.info("Display solution-select screen")

        # Pop up gui here
        selection = ask_question(self.root, "Select one option:", ["1", "2", "3"])
        self.env.assert_string(f"(solution-type {selection})")

        logging.info(f"You selected solution {selection}")
        logging.debug(f"Facts in working memory: {self.get_facts()}")

        self.set_message_box(f"Solution {selection} selected.")

        return False

    def case_steel_val_select(self, part, props):

        if part == "subframe":
            if props == "tensile":
                value = ask_entry(
                    self.root, "Enter the Subframe tensile strength target(MPa):"
                )
                value = value if value else 0
                self.env.assert_string(f"(subframe-tensile-strength {value})")
                self.set_message_box(f"Subframe Tensile Strength is {value} MPa")

            elif props == "yield":
                value = ask_entry(
                    self.root, "Enter the Subframe yield stress target(MPa):"
                )
                value = value if value else 0
                self.env.assert_string(f"(subframe-yield-stress {value})")
                self.set_message_box(f"Subframe Yield Stress is {value} MPa")

        elif part == "lc_arm":
            if props == "tensile":
                value = ask_entry(
                    self.root,
                    "Enter the Lower Control Arm tensile strength target(MPa):",
                )
                value = value if value else 0
                self.env.assert_string(f"(lc_arm-tensile-strength {value})")
                self.set_message_box(
                    f"Lower Control Arm Tensile Strength is {value} MPa"
                )

            elif props == "tensile-min-duct":
                value = ask_question(
                    self.root,
                    "Select the Lower Control Arm minimum tensile strength target(MPa):",
                    ["450", "550", "1100"],
                )
                self.env.assert_string(f"(lc_arm-tensile-strength-min {value})")
                self.set_message_box(
                    f"Lower Control Arm Minimum Tensile Strength is {value} MPa"
                )

            elif props == "tensile-min-usib":
                value = ask_question(
                    self.root,
                    "Select the Lower Control Arm minimum tensile strength target(MPa):",
                    ["1400", "1800"],
                )
                self.env.assert_string(f"(lc_arm-tensile-strength-min {value})")
                self.set_message_box(
                    f"Lower Control Arm Minimum Tensile Strength is {value} MPa"
                )

        elif part == "rearcradle":
            if props == "tensile":
                value = ask_entry(
                    self.root, "Enter the Rear Cradle tensile strength target(MPa):"
                )
                value = value if value else 0
                self.env.assert_string(f"(rearcradle-tensile-strength {value})")
                self.set_message_box(f"Rear Cradle Tensile Strength is {value} MPa")

            elif props == "yield":
                value = ask_entry(
                    self.root, "Enter the Rear Cradle yield stress target(MPa):"
                )
                value = value if value else 0
                self.env.assert_string(f"(rearcradle-yield-stress {value})")
                self.set_message_box(f"Rear Cradle Yield Stress is {value} MPa")

        elif part == "trail-arm" and props == "tensile":
            value = ask_entry(
                self.root, "Enter the Trailing Arms tensile strength target(MPa):"
            )
            value = value if value else 0
            self.env.assert_string(f"(trailingarm-tensile-strength {value})")
            self.set_message_box(f"Trailing Arms Tensile Strength is {value} MPa")

        return False

    def case_exit(self):
        logging.debug("Program reached a conclusion")
        logging.debug(f"Final facts after conclusion reached: {self.get_facts()}")
        self.reset = True

        return True

    def check_buffer(self):
        return self.buffer.split("?") if "?" in self.buffer else self.buffer

    def set_buffer(self, text):
        self.buffer = text

    def set_message_box(self, text):
        self.label.config(text=text)
