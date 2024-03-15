document.getElementById('description').addEventListener("input", function () {
    var description = document.getElementById("description");
    var letterCount = description.value.length;
    var words_count = document.getElementById("words_count")
    words_count.textContent = letterCount + "/300";
    if (letterCount >= 300) {
        words_count.classList.remove('text-[red]')
        words_count.classList.add('text-[#3B42A2]')
        description.classList.remove('focus:border-[red]')
        description.classList.add('focus:border-[#3B42A2]')
    } else {
        words_count.classList.remove('text-[#3B42A2]')
        words_count.classList.add('text-[red]')
        description.classList.remove('focus:border-[#3B42A2]')
        description.classList.add('focus:border-[red]')
    }
})

function categories(category_input_field, key) {
    var value = key === 'from_input' ? document.getElementById('input_categories').value : category_input_field.innerText
    var push_value = value.split(' ').join('_')
    var categoriesError = document.getElementById('categories_error')
    var close_img = document.getElementById('remove-categories-img')

    var categoriesField = document.getElementById('categories');
    var categories_values = JSON.parse(categoriesField.value || '[]');
    if(categories_values.includes(push_value) ) {
        categoriesError.innerText = `${key === 'from_input' ? value : category_input_field.innerText} already present`
        return
    }
    categoriesError.innerText = ""
    categories_values.push(push_value);
    categoriesField.value = JSON.stringify(categories_values);
    document.getElementById('input_categories').value = ""
    var mainDiv = document.getElementById('categories_show')
    var categoriesDiv = document.createElement('div')
    categoriesDiv.setAttribute('class', 'inline-block')
    categoriesDiv.setAttribute('id', `${push_value}`)

    var categoriesInnerDiv = document.createElement('div')
    categoriesInnerDiv.setAttribute('class', 'flex flex-row bg-[#3FB7CB] rounded-lg p-2 ml-2 mt-2')

    var p = document.createElement('p')
    p.innerText = value
    p.setAttribute('class', 'text-white')
    p.setAttribute('name', 'categories[]')

    var img = document.createElement('img')
    img.src = close_img.src
    img.setAttribute('class', 'w-5 h-5 pt-1 cursor-pointer mt-[2px]')
    img.setAttribute('onclick', `delete_categories(${push_value})`)

    categoriesInnerDiv.append(p)
    categoriesInnerDiv.append(img)
    categoriesDiv.append(categoriesInnerDiv)
    mainDiv.append(categoriesDiv)
    document.getElementById('add_button').style.display = 'none'
}

function delete_categories(value) {
    var element = document.getElementById(value.id)
    element.remove()
    var categoriesField = document.getElementById('categories');
    var categories_values = JSON.parse(categoriesField.value || '[]');
    var index = categories_values.indexOf(element.innerText.split(' ').join('_').trim());
    if (index !== -1) {
        categories_values.splice(index, 1);
        categoriesField.value = JSON.stringify(categories_values);
    }
}

function show_add_button(input) {
    if (input.value !== "") {
        document.getElementById('add_button').style.display = 'block'
    } else {
        document.getElementById('add_button').style.display = 'none'
    }
}

function openSheet() {
    const bottomSheet = document.getElementById('bottomSheet');
    bottomSheet.style.bottom = '0';
}

function closeBottom() {
    const bottomSheet = document.getElementById('bottomSheet');
    bottomSheet.style.bottom = '-100%';
}

function createDataTransfer(imagesData) {
    var dataTransfer = new DataTransfer();
    imagesData.forEach(function(data, index) {
        var file = new File([data], 'image_' + index + '.jpeg', { type: 'image/jpeg' });
        dataTransfer.items.add(file);
    });

    return dataTransfer;
}


async function addBlog(key) {
    var loader = document.getElementById('main_loader')
    var overlay = document.getElementById('overlay')
    loader.style.display = 'flex'
    overlay.style.display = 'block'
    var response = key === 'create' ? check_validations() : draft_check_validations()
    if (response) {
        var title = document.getElementById('title').value
        var description = document.getElementById('description').value
        var categories = document.getElementById('categories').value
        var editor = document.getElementById('editor');
        var formData = new FormData();
        var imagesArray = [];
        var imgTags = editor.childNodes[0].querySelectorAll('img')
        if (imgTags.length !== 0) {
            await Promise.all(Array.from(imgTags).map(async function(img) {
                try {
                    const res = await fetch(img.src);
                    const blob = await res.blob();
                    const file = new File([blob], 'dot.png', { type: blob.type });
                    imagesArray.push(file);
                } catch (error) {
                    console.error('Error fetching image:', error);
                }
            }));
            var dataTransfer = createDataTransfer(imagesArray);
            for (var i = 0; i < dataTransfer.files.length; i++) {
                formData.append('details_images[]', dataTransfer.files[i]);
            }
        }
        var csrfToken = $('meta[name="csrf-token"]').attr('content');
        formData.append('authenticity_token', csrfToken);
        formData.append('title', title);
        formData.append('description', description);
        formData.append('categories', categories);
        if ($('#dropzone-file')[0].files.length !== 0) {
            formData.append('thumbnail', $('#dropzone-file')[0].files[0])
        }
        await sendFormData(formData, imgTags, editor, overlay, loader, key)
    } else {
        loader.style.display = 'none'
        overlay.style.display = 'none'
        if(key === 'draft') {
            $.toast({
                heading: 'error',
                text: 'Description or Details required to draft',
                showHideTransition: 'slide',
                position: 'top-right',
                icon: 'error',
                hideAfter: 5000,
                bgColor: 'red',
                textColor: 'white',
            })
        }
    }
}

async function sendFormData(formData, imgTage, editor, overlay, loader, key) {
    $.ajax({
        url: `${key === 'create' ? "/blogs" : '/draft'}`,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: async function (res) {
            for(var i=0; i < imgTage.length; i++) {
                imgTage[i].src = res?.images_urls[i]
            }
            await updateBlog(editor, res?.blog_id, overlay, loader, key)
        }
    })
}

async function updateBlog(editor, blog_id, overlay, loader, key) {
    var codeBlocks = document.querySelectorAll('.ql-code-block');
    codeBlocks.forEach(function(block) {
        var language = block.getAttribute('data-language') || 'plain';
        var content = block.innerHTML;
        block.innerHTML = '<pre class="language-' + language + '"><code>' + content + '</code></pre>';
    });
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    var formData = new FormData();
    formData.append('details', $('#editor .ql-editor').html());
    formData.append('id', blog_id)
    formData.append('authenticity_token', csrfToken);
    $.ajax({
        url: `${key === 'create' ? "/blogs/blog_details" : "/draft/draft_details"}`,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (res) {
            $.toast({
                heading: 'Success',
                text: `${key === 'create' ? "Blog created successfully" : "Blog added in your drafts"}`,
                showHideTransition: 'slide',
                position: 'top-right',
                icon: 'success',
                hideAfter: 5000,
                bgColor: '#5995fd',
                textColor: 'white',
                afterHidden: function () {
                    window.location.href = '/';
                }
            })
        }
    })
}

function check_validations() {
    var inputFields = [
        { id: `#title`, label: `#title_error`, message: "Title can't be blank" },
        { id: `#description`, label: `#description_error`, message: "Description can't be blank" },
        { id: `#categories`, label: `#categories_error`, message: 'There must be at least one category' },
        { id: `#dropzone-file`, label: `#thumbnail_error`, message: "Select the thumbnail first" },
        { id: `#editor`, label: `#details-error`, message: "Details can't be blank" },
    ];

    var isValid = true;

    for (var i = 0; i < inputFields.length; i++) {
        var field = $(inputFields[i].id)[0]
        var errorElement = $(inputFields[i].label)[0];
        if (inputFields[i].id === '#editor' && field.childNodes[0].childNodes[0].innerText === '\n'){
            errorElement.innerText = inputFields[i].message;
            isValid = false;
        } else if (inputFields[i].id === '#dropzone-file' && field.files.length === 0) {
            errorElement.innerText = inputFields[i].message;
            isValid = false;
        } else if (inputFields[i].id === '#description') {
            if (field.value === "") {
                field.classList.add('border-2')
                field.classList.add('border-[red]')
                errorElement.innerText = inputFields[i].message;
                isValid = false;
            } else if (field.value.length < 300) {
                field.classList.add('border-2')
                field.classList.add('border-[red]')
                errorElement.innerText = "Minimum 300 letters"
                isValid = false;
            }
        } else {
            if (field.value === "") {
                errorElement.innerText = inputFields[i].message;
                isValid = false;
            } else {
                errorElement.innerText = '';
            }
        }
    }

    return isValid;
}

function draft_check_validations() {
    var inputFields = [
        { id: `#description`, label: `#description_error`, message: "Description can't be blank" },
        { id: `#editor`, label: `#details-error`, message: "Details can't be blank" },
    ];

    var isValid = false;

    for (var i = 0; i < inputFields.length; i++) {
        var field = $(inputFields[i].id)[0]
        var errorElement = $(inputFields[i].label)[0];
        if (inputFields[i].id === '#editor'){
            if (field.childNodes[0].childNodes[0].innerText !== '\n') {
                isValid = true
            } else {
                errorElement.innerText = inputFields[i].message;
            }
        }

        if (inputFields[i].id === '#description') {
            if (field.value === "") {
                field.classList.add('border-2')
                field.classList.add('border-[red]')
                errorElement.innerText = inputFields[i].message;
            } else if (field.value.length < 300) {
                field.classList.add('border-2')
                field.classList.add('border-[red]')
                errorElement.innerText = "Minimum 300 letters"
            } else {
                isValid = true
            }
        }
    }
    return isValid;
}

document.addEventListener("DOMContentLoaded", function() {
    const dropzone = document.getElementById("dropzone");
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, preventDefaults, false);
        document.body.addEventListener(eventName, preventDefaults, false);
    });
    ['dragenter', 'dragover'].forEach(eventName => {
        dropzone.addEventListener(eventName, highlight, false);
    });
    ['dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, unhighlight, false);
    });
    dropzone.addEventListener('drop', handleDrop, false);
});

function preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
}

function highlight() {
    this.classList.add('border-blue-500');
}

function unhighlight() {
    this.classList.remove('border-blue-500');
}

function handleDrop(e) {
    preventDefaults(e);
    const files = e.dataTransfer.files;
    handleFiles(files);
}

function handleFiles(files) {
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function (file) {
        var img = new Image();
        img.src = file.target.result;
        img.onload = function() {
            if(this.width < 500 || this.height < 800) {
                $('#thumbnail_error')[0].innerText = `Minimum dimensions are 500 x 800.Your image is ${this.width} x ${this.height}`
            } else  {
                img.setAttribute("class", "overflow-hidden opacity-100 object-cover")
                img.setAttribute("id", "dropzone-file-show")
                $('#dropzone-file-show').replaceWith(img)
                $('#dropzone-file')[0].files = files
                $('#thumbnail_error')[0].innerText = ""
            }
        };
    }
    reader.readAsDataURL(image);
}

$('#dropzone-file').on('change', function (event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function (file) {
        var img = new Image();
        img.src = file.target.result;
        img.onload = function() {
            if(this.width < 500 || this.height < 800) {
                $('#thumbnail_error')[0].innerText = `Minimum dimensions are 500 x 800.Your image is ${this.width} x ${this.height}`
                var dataTransfer = new DataTransfer()
                $('#dropzone-file')[0].files = dataTransfer.files
            } else  {
                img.setAttribute("class", "overflow-hidden opacity-100 object-cover")
                img.setAttribute("id", "dropzone-file-show")
                $('#dropzone-file-show').replaceWith(img)
                $('#thumbnail_error')[0].innerText = ""
            }
        };
    }
    reader.readAsDataURL(image);
});
