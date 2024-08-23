import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["editor", "input"]

    connect() {

        var Block = Quill.import('blots/block');
        Block.tagName = 'DIV';
        Quill.register(Block, true);
        Quill.register({
            'modules/better-table': quillBetterTable
        }, true);
        var tableOptions = [];
        var maxRows = 10;
        var maxCols = 10;
        for (let r = 1; r <= maxRows; r++) {
            for (let c = 1; c <= maxCols; c++) {
                tableOptions.push('newtable_' + r + '_' + c);
            }
        }
        const toolbarOptions = [
            ['bold', 'italic', 'underline', 'strike'],
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'font': [] }],
            [{ 'header': 1 }, { 'header': 2 }],
            [{ 'color': [] }, { 'background': [] }],
            ['blockquote', 'code-block'],
            ['link', 'image', 'video', 'formula'],
            [{ 'list': 'ordered'}, { 'list': 'bullet' }, { 'list': 'check' }],
            [{ 'align': [] }],
            [{ 'script': 'sub'}, { 'script': 'super' }],
            [{ 'indent': '-1'}, { 'indent': '+1' }],
            [{ 'direction': 'rtl' }],
            ['clean'],
            [{'Table-Input': tableOptions}]
        ];


        var quill = new Quill(this.editorTarget, {
            modules: {
                table: false,
                syntax: true,
                toolbar: toolbarOptions,
                'better-table': {
                    operationMenu: {
                        items: {
                            unmergeCells: {
                                text: 'Unmerge cells'
                            }
                        },
                        color: {
                            colors: ['green', 'red', 'yellow', 'blue', 'white'],
                            text: 'Background Colors:'
                        }
                    }
                },
            },
            placeholder: 'Start Typing Here...',
            theme: 'snow',
        });

        var quillEditor = $('#editor')
        var curTableIconSpan = quillEditor.parent().find('span.ql-Table-Input.ql-picker')[0].childNodes[0];
        curTableIconSpan.innerHTML = "<svg style=\"right: 4px;\" viewbox=\"0 0 18 18\"> <rect class=ql-stroke height=12 width=12 x=3 y=3></rect> <rect class=ql-fill height=2 width=3 x=5 y=5></rect> <rect class=ql-fill height=2 width=4 x=9 y=5></rect> <g class=\"ql-fill ql-transparent\"> <rect height=2 width=3 x=5 y=8></rect> <rect height=2 width=4 x=9 y=8></rect> <rect height=2 width=3 x=5 y=11></rect> <rect height=2 width=4 x=9 y=11></rect> </g> </svg>";
        var curTableCellIconSpans = $(curTableIconSpan.parentNode.childNodes[1]).children();
        curTableCellIconSpans.click((function(){
            var curQuillBetterTable = quill.getModule('better-table');
            var curQuillToolbar = quill.getModule('toolbar');
            return function() {
                var curRowIndex = Number(this.dataset.value.substring(9).split('_')[0]);
                var curColIndex = Number(this.dataset.value.substring(9).split('_')[1]);
                curQuillBetterTable.insertTable(curRowIndex, curColIndex);
                $(this).parent().parent().find(".ql-selected").removeClass("ql-selected");
                $(this).parent().parent().find(".ql-active").removeClass("ql-active");
            };
        })());
        curTableCellIconSpans.hover(function(){
            var curRowIndex = Number(this.dataset.value.substring(9).split('_')[0]);
            var curColIndex = Number(this.dataset.value.substring(9).split('_')[1]);
            $(this).parent().children().each((function() {
                var curRowIndex1 = curRowIndex;
                var curColIndex1 = curColIndex;
                return function() {
                    var curRowIndex2 = Number(this.dataset.value.substring(9).split('_')[0]);
                    var curColIndex2 = Number(this.dataset.value.substring(9).split('_')[1]);
                    if (curRowIndex2 <= curRowIndex1 && curColIndex2 <= curColIndex1) {
                        $(this).addClass("ql-picker-item-highlight");
                    }
                };
            })());


        }, function(){
            $(this).parent().children().removeClass("ql-picker-item-highlight");
        });
        // this.table = this.quill.getModule('table');

        // document.getElementById('add-table-button').addEventListener('click', () => {
        //     var table = prompt("Enter rows and columns separated by 'x' (e.g., '2x3' for 2 rows and 3 columns):");
        //     if (table !== null) {
        //         table = table.trim();
        //         if (table !== "") {
        //             var [rows, columns] = table.split('x').map(Number);
        //             if (!isNaN(rows) && !isNaN(columns) && rows > 0 && columns > 0) {
        //                 this.table.insertTable(rows - 1, columns);
        //             } else {
        //                 alert("Invalid input. Please enter valid numbers for rows and columns.");
        //             }
        //         }
        //     }
        //
        // });

        // this.quill.container.firstChild.innerHTML = this.inputTarget.value;
        // this.quill.on('text-change', (delta, oldDelta, source) => {
        //     this.inputTarget.value = this.quill.container.firstChild.innerHTML;
        // });
        //
        // document.querySelectorAll('.ql-column-left').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-left-square" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M10.205 12.456A.5.5 0 0 0 10.5 12V4a.5.5 0 0 0-.832-.374l-4.5 4a.5.5 0 0 0 0 .748l4.5 4a.5.5 0 0 0 .537.082z"/></svg>'
        //     button.title = "Add column left";
        //     button.addEventListener('click', () => {
        //         this.table.insertColumnLeft();
        //     });
        // });
        //
        // document.querySelectorAll('.ql-column-right').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-right-square" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M5.795 12.456A.5.5 0 0 1 5.5 12V4a.5.5 0 0 1 .832-.374l4.5 4a.5.5 0 0 1 0 .748l-4.5 4a.5.5 0 0 1-.537.082z"/></svg>';
        //     button.title = "Add column right";
        //     button.addEventListener('click', () => {
        //         this.table.insertColumnRight();
        //     });
        // });
        //
        // document.querySelectorAll('.ql-row-above').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-up-square" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M3.544 10.705A.5.5 0 0 0 4 11h8a.5.5 0 0 0 .374-.832l-4-4.5a.5.5 0 0 0-.748 0l-4 4.5a.5.5 0 0 0-.082.537z"/></svg>';
        //     button.title = "Add row above";
        //     button.addEventListener('click', () => {
        //         this.table.insertRowAbove();
        //     });
        // });
        //
        // document.querySelectorAll('.ql-row-below').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-down-square" viewBox="0 0 16 16"><path d="M3.626 6.832A.5.5 0 0 1 4 6h8a.5.5 0 0 1 .374.832l-4 4.5a.5.5 0 0 1-.748 0l-4-4.5z"/><path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm15 0a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2z"/></svg>'
        //     button.title = "Add row below";
        //     button.addEventListener('click', () => {
        //         this.table.insertRowBelow();
        //     });
        // });
        //
        // document.querySelectorAll('.ql-row-remove').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-dash-square" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M4 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 4 8z"/></svg>';
        //     button.title = "Remove row";
        //     button.addEventListener('click', () => {
        //         this.table.deleteRow();
        //     });
        // });
        //
        // document.querySelectorAll('.ql-column-remove').forEach(button => {
        //     button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16"><path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/><path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg>';
        //     button.title = "Remove column";
        //     button.addEventListener('click', () => {
        //         this.table.deleteRow();
        //     });
        // });
    }

    // show_modal() {
    //     document.getElementById('table-modal').classList.remove('hidden')
    //     document.getElementById('table-modal').classList.add('flex')
    // }
    //
    // hide_modal() {
    //     document.getElementById('table-modal').classList.remove('flex')
    //     document.getElementById('table-modal').classList.add('hidden')
    // }

    disconnect() {
        if (this.quill) {
            this.quill = null;
        }
        if (this.table) {
            this.table = null;
        }
    }

    focus() {
        $('.ql-picker-label').removeClass('ql-active')
        this.editorTarget.focus();
    }

    // add_table() {
    //     var rowsTable = parseInt(document.getElementById('rows').value)
    //     var columnsTable = parseInt(document.getElementById('columns').value)
    //     if (rowsTable && columnsTable) {
    //         if (!isNaN(rowsTable) && !isNaN(columnsTable) && rowsTable > 0 && columnsTable > 0) {
    //             debugger
    //             this.table.insertTable(rowsTable - 1, columnsTable);
    //             document.getElementById('table-modal').classList.add('hidden')
    //             document.getElementById('table-modal').classList.remove('flex')
    //         } else {
    //             alert("Invalid input. Please enter valid numbers for rows and columns.");
    //         }
    //     }
    // }

}
