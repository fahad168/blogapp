import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["editor", "input"]

    connect() {

        var Block = Quill.import('blots/block');
        Block.tagName = 'DIV';
        Quill.register(Block, true);
        // const toolbarOptions = [
        //     ['bold', 'italic', 'underline', 'strike'],
        //     // [{'header': [1, 2, 3, 4, 5, 6, false]}],
        //     // [{'font': []}],
        //     // [{'header': 1}, {'header': 2}],
        //     // [{'color': []}, {'background': []}],
        //     ['link'],
        // ];


        this.quill = new Quill(this.editorTarget, {
            modules: {
                table: false,
                syntax: false,
                toolbar: "#toolbar-container",
            },
            placeholder: 'Start Typing Here...',
            theme: 'snow',
        });
    }

    disconnect() {
        if (this.quill) {
            this.quill = null;
        }
    }

    focus() {
        this.editorTarget.focus();
    }

}
