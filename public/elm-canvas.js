customElements.define(
  "elm-canvas",
  class extends HTMLElement {
    constructor() {
      super();
      this.commands = [];
      this.mounted = false;
    }

    set cmds(values) {
      this.commands = values;
      this.render();
    }

    connectedCallback() {
      requestAnimationFrame(() => {
        this.canvas = this.querySelector("canvas");
        this.context = this.canvas.getContext("2d");
        this.mounted = true;
        this.render();
      });
    }

    render() {
      if (!this.mounted) return;
      // Iterate over the commands in reverse order as that's how the Elm side
      // builds them as with the linked lists
      for (let i = this.commands.length - 1; i >= 0; i--) {
        this.execCommand(this.commands[i]);
      }
      this.commands = [];
    }

    execCommand(cmd) {
      if (cmd.type === "function") {
        this.context[cmd.name](...cmd.args);
      } else if (cmd.type === "field") {
        this.context[cmd.name] = cmd.value;
      }
    }
  }
);
