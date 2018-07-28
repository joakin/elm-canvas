customElements.define(
  "elm-canvas",
  class extends HTMLElement {
    constructor() {
      super();
      this.commands = [];
      this.mounted = false;
    }

    set cmds(values) {
      values.forEach(value => this.commands.push(value));
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
      this.commands.forEach(value => this.execCommand(value));
      this.commands = [];
    }

    execCommand(cmd) {
      if (cmd.type === "function") {
        this.context[cmd.name](...cmd.args);
      } else if (cmd.type === "field") {
        this.context[cmd.name] = cmd.value;
      } else if (cmd.type === "batch") {
        cmd.values.forEach(cmd => this.execCommand(cmd));
      }
    }
  }
);
