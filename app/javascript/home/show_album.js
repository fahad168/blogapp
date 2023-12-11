function show_album(id) {
    const loaderContainer = document.getElementById("loader-container");
    const overlay = document.getElementById("overlay");
    overlay.classList.remove('hidden')
    overlay.style.display = "block"
    loaderContainer.style.display = "block"
    $.ajax({
        type: 'GET',
        url: `/album?id=${id}`,
        success: function (res) {
            $('#albumInnerModal').html(res.entries)
            document.getElementById('albumModal').style.display = "flex"
            document.getElementById('albumModal').style.justifyContent = "center"
            loaderContainer.style.display = "none"
        }
    })
}

function hideAlbumModal() {
    document.getElementById('albumModal').style.display = "none"
    const overlay = document.getElementById("overlay");
    overlay.classList.add('hidden')
    overlay.style.display = "none"
}
