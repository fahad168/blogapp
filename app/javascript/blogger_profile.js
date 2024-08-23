$('.country_select').chosen({
    disable_search_threshold: 10,
    placeholder_text_multiple: 'Select Countries',
    no_results_text: 'No country found',
    width: '100%'
});

$(function () {
    $('#profile_image').on('change', function (event) {
        var files = event.target.files;
        var image = files[0]
        var reader = new FileReader();
        reader.onload = function (file) {
            var img = new Image();
            img.src = file.target.result;
            img.setAttribute("class", "w-[5rem] h-[5rem] rounded-full absolute border")
            img.setAttribute("id", "user-image")
            $('#user-image').replaceWith(img)
        }
        reader.readAsDataURL(image);
    });
});

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
            img.setAttribute("class", "overflow-hidden opacity-100 object-cover")
            img.setAttribute("id", "dropzone-file-show")
            $('#dropzone-file-show').replaceWith(img)
            $('#dropzone-file')[0].files = files
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
            img.setAttribute("class", "overflow-hidden opacity-100 object-cover")
            img.setAttribute("id", "dropzone-file-show")
            $('#dropzone-file-show').replaceWith(img)
        };
    }
    reader.readAsDataURL(image);
});

function edit_profile() {
    $('#profile_toggle_modal').click()
    var mainLoader = document.getElementById('main_loader')
    var overlay = document.getElementById('overlay')
    mainLoader.style.display = 'flex'
    overlay.style.display = 'block'
    var formData = new FormData()
    var jobTitle = document.getElementById('job_title')
    var location = document.getElementById('country')
    var profileImage = document.getElementById('profile_image')
    var coverImage = document.getElementById('dropzone-file')
    if (coverImage.files.length > 0) {
        formData.append('cover_image', coverImage.files[0])
    }
    if (profileImage.files.length > 0) {
        formData.append('profile_image', profileImage.files[0])
    }
    if (location.value) {
        formData.append('location', location.value)
    }
    if (jobTitle.value) {
        formData.append('job_title', jobTitle.value)
    }
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    formData.append('authenticity_token', csrfToken);
    formData.append('type', 'edit_profile');
    $.ajax({
        type: 'POST',
        url: '/profile/blogger_profile_edit',
        data: formData,
        processData: false,
        contentType: false,
        success: function (res) {
            $('#top_profile_section').html(res?.entries)
            mainLoader.style.display = 'none'
            overlay.style.display = 'none'
        }
    })
}

$('.language_select').chosen({
    disable_search_threshold: 10,
    placeholder_text_multiple: 'Select Languages',
    no_results_text: 'No language found',
    width: '100%',
});

$('.nice-select').niceSelect()

function additional_details() {
    $('#additional-details-modal').click()
    var mainLoader = document.getElementById('main_loader')
    var overlay = document.getElementById('overlay')
    mainLoader.style.display = 'flex'
    overlay.style.display = 'block'
    var formData = new FormData()
    var gender = document.getElementById('gender')
    var nickname = document.getElementById('nickname')
    const nodeList = $('.chosen-choices')[0].childNodes
    if (nodeList.length > 0) {
        var nodeArray = Array.from(nodeList).slice(1, -2);
        var languages = [];
        nodeArray.forEach(node => {
            const span = node.querySelector('span');
            if (span) {
                languages.push(span.textContent);
            }
        });
        formData.append('languages', JSON.stringify(languages))
    }
    if (gender.value) {
        formData.append('gender', gender.value)
    }
    if (nickname.value) {
        formData.append('nickname', nickname.value)
    }
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    formData.append('authenticity_token', csrfToken);
    formData.append('type', 'additional_details');
    $.ajax({
        type: 'POST',
        url: '/profile/blogger_profile_edit',
        data: formData,
        processData: false,
        contentType: false,
        success: function (res) {
            $('#additional_details_div').html(res?.entries)
            mainLoader.style.display = 'none'
            overlay.style.display = 'none'
        }
    })
}

function edit_summary() {
    var summary = $('#summary')
    var summaryContent = $('#summary_content')
    if (summaryContent[0].innerText !== 'Summary not added') {
        summary[0].innerText = summaryContent[0].innerText
    }
    summary.removeClass('hidden')
    summaryContent.addClass('hidden')
    document.getElementById('tick').classList.remove('hidden')
    document.getElementById('cross').classList.remove('hidden')
    summary.focus()
    summary[0].setSelectionRange(summary[0].value.length, summary[0].value.length);
}

function restore_default(key) {
    var summary = $('#summary')
    var summaryContent = $('#summary_content')
    summaryContent[0].innerText = summary[0].value === "" ? "Summary not added" : key !== 'Ruby' ? summary[0].value : summaryContent[0].innerText
    summaryContent.removeClass('hidden')
    summary[0].value !== "" ? summaryContent.removeClass('text-center mb-4') : summaryContent.addClass('text-center mb-4')
    summary.addClass('hidden')
    document.getElementById('tick').classList.add('hidden')
    document.getElementById('cross').classList.add('hidden')
}

function save_summary() {
    var summary = document.getElementById('summary')
    restore_default('JS')
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        type: "POST",
        url: '/profile/blogger_profile_edit',
        data: { summary: summary.value, authenticity_token: csrfToken },
        success: function (res) {

        }
    })
}