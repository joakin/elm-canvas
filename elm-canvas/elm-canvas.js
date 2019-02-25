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

    static get observedAttributes() {
      return ['width', 'height'];
    }


    setCanvasDimensions(w, h){
        var devicePixelRatio = window.devicePixelRatio || 1;
        this.canvas.style.width = w;
        this.canvas.style.height = h;
        this.canvas.width = w * devicePixelRatio;
        this.canvas.height = h * devicePixelRatio;
        // Reset current transformation matrix to the identity matrix
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        this.context.scale(devicePixelRatio, devicePixelRatio);
    }

    connectedCallback() {
      requestAnimationFrame(() => {
        this.canvas = this.querySelector("canvas");
        this.context = this.canvas.getContext("2d");
        this.mounted = true;

        setCanvasDimensions(this.canvas.width, this.canvas.height);

        this.render();
      });
    }

    attributeChangedCallback(name, oldValue, newValue) {
      //we're assuming that only canvas.width or canvas.height can change
      setCanvasDimensions(this.canvas.width,this.canvas.height)
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
