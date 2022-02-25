function toggleNotifications(){
    if(notificationsHidden){
        showNotifications();
    } else {
        hideNotifications();
    }
}

function showNotifications(){
    for(let toast of toastList){
        toast.show();
    }
    notificationsHidden = false;
}

function hideNotifications(){
    for(let toast of toastList){
        toast.hide();
    }
    notificationsHidden = true;
}

function markAsRead(userId, notificationId){
    let url = '/api/user/' + userId + '/markNotificationAsRead';

    r = new URLEncodedRequest(url, 'POST');
    r.setParam('notification_id', notificationId);

    let notificationToast = document.getElementById('notification' + notificationId);

    r.send(function (xhr) {
        if(xhr.status == 200){
            notificationToast.remove();
            notificationCount -= 1;
            if(notificationCount == 1){
                noNotifications();
            }
        }
    });
}

function noNotifications(){
    document.getElementById('noNotificationsToast').hidden = false;
    document.getElementById('notificationBadge').hidden = true;
}

let toastElList = [].slice.call(document.querySelectorAll('.toast'));
let toastList = toastElList.map(function (toastEl) {
  let t = new bootstrap.Toast(toastEl, 'show');
  return t;
});
let notificationsHidden = true;
let notificationCount = toastElList.length;

if(notificationCount > 1){
    document.getElementById('notificationBadge').hidden = false;
} else if(notificationCount == 1) {
    noNotifications();
}
