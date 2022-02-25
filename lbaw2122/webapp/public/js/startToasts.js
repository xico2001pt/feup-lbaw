var toastElList = [].slice.call(document.querySelectorAll('.toast'))
var toastList = toastElList.map(function (toastEl) {
  let t = new bootstrap.Toast(toastEl, 'show');
  return t;
})
