$(document).ready(function () {
    $('.nice-select').niceSelect()
    $('.chosen-select').chosen({
        disable_search_threshold: 10,
        placeholder_text_single: 'Select Movies',
        no_results_text: 'No results found',
    });
})

function show_genre(dropdown) {
    if (dropdown.value === 'movie') {
        document.getElementById('movie_genre').style.display = "block"
        document.getElementById('tv_genre').style.display = "none"
    }else if(dropdown.value === 'tv' ) {
        document.getElementById('movie_genre').style.display = "none"
        document.getElementById('tv_genre').style.display = "block"
    }
}

function moviesDropDownData(value) {
    if(value !== 'Select Movie Genre') {
        const loaderContainer = document.getElementById("loader-container1");
        loaderContainer.style.display = "flex"
        $.ajax({
            type: 'GET',
            url: `movies_dropdown_data?genre_id=${value}`,
            success: function (res) {
                var movies_ids = $('#movies_ids')
                var moviesDropdown = $('#moviesDropdown ul')
                movies_ids.empty()
                moviesDropdown.empty()
                movies_ids.append(res.entries)
                moviesDropdown.append(res.entries)
                document.getElementById('moviesDropdown').style.display = "block"
                loaderContainer.style.display = "none"
            }
        })
    }
}

function showDropDownData(value) {
    if(value !== 'Select Tv Genre') {
        const loaderContainer = document.getElementById("loader-container1");
        loaderContainer.style.display = "flex"
        $.ajax({
            type: 'GET',
            url: `show_dropdown_data?genre_id=${value}`,
            success: function (res) {
                var show_ids = $('#show_ids')
                var showDropdown = $('#tvDropdown ul')
                show_ids.empty()
                showDropdown.empty()
                show_ids.append(res.entries)
                showDropdown.append(res.entries)
                document.getElementById('tvDropdown').style.display = "block"
                loaderContainer.style.display = "none"
            }
        })
    }
}

function selected_movie() {
    document.getElementById('ids').value = $('#moviesDropdown ul li.selected')[0].dataset.value
}

function selected_show() {
    document.getElementById('season_ids').value = $('#tvDropdown ul li.selected')[0].dataset.value
}

function handle_album_image(input) {
    document.getElementById('album_filename').innerText = input.files[0].name
}

function handle_image(input) {
    document.getElementById('filename').innerText = input.files[0].name
}

function handle_image_profile(input) {
    document.getElementById('filenameProfile').innerText = input.files[0].name
}

function cancel_image() {
    var images = $('#file')[0];
    if (images.files.length > 0) {
        const dataTransfer = new DataTransfer();
        images.files = dataTransfer.files
        document.getElementById('filename').innerText = "Not selected file"
    }
}

function cancel_profile_image() {
    var images = $('#files')[0];
    if (images.files.length > 0) {
        const dataTransfer = new DataTransfer();
        images.files = dataTransfer.files
        document.getElementById('filenameProfile').innerText = "Not selected file"
    }
}

function cancel_album_image() {
    var images = $('#album_file')[0];
    if (images.files.length > 0) {
        const dataTransfer = new DataTransfer();
        images.files = dataTransfer.files
        document.getElementById('album_filename').innerText = "Not selected file"
    }
}


function show_image(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function (file) {
        var img = new Image();
        img.src = file.target.result;
        img.setAttribute("class", "w-[10rem] h-[10rem] rounded-full overflow-hidden opacity-100 object-cover border-2 border-white")
        img.setAttribute("id", "user-image")
        $('#user-image').replaceWith(img)
    }
    reader.readAsDataURL(image);
}
