function drawer(id){
    document.getElementById('drawer_text').innerText = `Are you sure you want to delete this Blog?`
    document.getElementById('delete_button').href = `/my_blogs/${id}`
}

function checkedRow(id, type) {
    if (type !== "fromOtherJSFunction") {
        document.getElementById('checkbox-all-search').checked = false
    }
    var idsArrayElement = $('#blog_ids');
    var historyButton = $('#deleteButton');

    var currentArrayString = idsArrayElement.val();
    var hiddenArray = currentArrayString ? currentArrayString.split(',') : [];
    var isIdInArray = hiddenArray.includes(id);

    if (isIdInArray) {
        hiddenArray = hiddenArray.filter(item => item !== id);
    } else {
        hiddenArray.push(id);
    }
    idsArrayElement.val(hiddenArray.join(','));
    historyButton[0].innerText = `${hiddenArray.length} Delete`
    var isArrayEmpty = hiddenArray.length === 0;
    if (isArrayEmpty) {
        historyButton.addClass('hidden');
    } else {
        historyButton.removeClass('hidden');
        document.getElementById('drawer_text').innerText = `Are you sure you want to delete ${hiddenArray.length} Blog?`
        document.getElementById('delete_button').href = `/my_blogs/bulk_delete?ids=${hiddenArray.join(',')}`
    }
}

function checkAllOfThem(input) {
    var checkboxes = document.querySelectorAll('#checkbox')
    checkboxes.forEach(function (checkbox) {
        checkbox.checked = false
    })
    $('#blog_ids')[0].value = "";
    if(input.checked === true) {
        checkboxes.forEach(function (checkbox) {
            checkedRow(checkbox.value, 'fromOtherJSFunction')
            checkbox.checked = true
        })
    } else {
        checkboxes.forEach(function (checkbox) {
            checkedRow(checkbox.value)
            checkbox.checked = false
        })
    }
}