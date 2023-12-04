function create_following(following_id) {
    const loaderContainer = document.getElementById("loader-container1");
    loaderContainer.style.display = "flex"
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        type: 'POST',
        url: '/create_following',
        data: { following_id: following_id, authenticity_token: csrfToken },
        success: function (response) {
            if(response?.message){
                toast(response?.message, 'success', 'green')
                create_requested_button(following_id)
            }else {
                toast(response?.message, 'error', 'red')
            }
            loaderContainer.style.display = "none"
        }
    })
}

function cancel_following(following_id) {
    const loaderContainer = document.getElementById("loader-container1");
    loaderContainer.style.display = "flex"
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        type: 'POST',
        url: '/cancel_following',
        data: { following_id: following_id, authenticity_token: csrfToken },
        success: function (response) {
            if(response?.message){
                toast(response?.message, 'success', 'green')
                create_follow_button(following_id)
            }else {
                toast(response?.message, 'error', 'red')
            }
            loaderContainer.style.display = "none"
        }
    })
}

function toast(message, type, color) {
    $.toast({
        heading: type,
        text: message,
        showHideTransition: 'slide',
        position: 'top-right',
        icon: type,
        hideAfter: 5000,
        bgColor: color,
        textColor: 'white'
    })
}

function create_follow_button(following_id) {
    var button = document.createElement("button");
    button.type = "button";
    button.className = `relative py-2 px-8 text-black text-base font-bold uppercase rounded-lg overflow-hidden bg-white transition-all duration-400 ease-in-out shadow-md hover:scale-105 hover:text-white hover:shadow-lg active:scale-90 before:absolute before:top-0 before:-left-full before:w-full before:h-full before:bg-gradient-to-r before:from-blue-500 before:to-blue-300 before:transition-all before:duration-500 before:ease-in-out before:z-[-1] before:rounded-lg hover:before:left-0`;
    button.innerHTML = 'Follow';
    button.setAttribute('id', `button${following_id}`)

    button.onclick = function () {
        create_following(following_id)
    };
    document.getElementById(`button${following_id}`).replaceWith(button);
}

function create_requested_button(following_id) {
    var button = document.createElement("button");
    button.id = `button${following_id}`;
    button.type = "button";
    button.className = "btn relative px-8 w-[8rem] text-white text-base font-bold uppercase rounded-lg overflow-hidden bg-transparent border-2 border-[white] transition-all duration-400 ease-in-out shadow-md hover:scale-105 hover:text-white hover:shadow-lg active:scale-90 before:absolute before:top-0 before:-left-full before:w-full before:h-full hover:border-0 before:bg-gradient-to-r before:from-red-900 before:to-red-800 before:transition-all before:duration-500 before:ease-in-out before:z-[-1] before:rounded-lg hover:before:left-0";

    var span1 = document.createElement("span");
    span1.className = "btn-text-one";
    span1.textContent = "Requested";
    button.appendChild(span1);

    var span2 = document.createElement("span");
    span2.className = "btn-text-two";
    span2.textContent = "Cancel";
    button.appendChild(span2);
    var style = document.createElement("style");
    style.textContent = `
            .btn .btn-text-one {
                position: absolute;
                width: 100%;
                top: 50%;
                left: 0;
                transform: translateY(-50%);
                transition: top 0.5s;
            }

            .btn:hover .btn-text-one {
                top: -100%;
            }

            .btn .btn-text-two {
                position: absolute;
                width: 100%;
                top: 150%;
                left: 0;
                transform: translateY(-50%);
                transition: top 0.5s;
            }

            .btn:hover .btn-text-two {
                top: 50%;
            }
        `;

    button.onclick = function () {
        cancel_following(following_id)
    };
    document.getElementById(`button${following_id}`).appendChild(style);
    document.getElementById(`button${following_id}`).replaceWith(button);
}
