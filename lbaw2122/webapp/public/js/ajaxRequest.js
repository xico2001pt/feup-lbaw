class AJAXRequest {
    constructor(url, method, encoding) {
        this.url = url;
        this.method = method;
        this.encoding = encoding;
        this.body = null;
    }

    //setParam(key, value) { throw "Must be implemented by subclass!"; }

    send(callback) {
        const xhr = new XMLHttpRequest();
        xhr.open(this.method, BASE_URL + this.url, true);
        let csrf_token = document.head.querySelector("[name~=csrf-token][content]").content;
        xhr.setRequestHeader('X-CSRF-TOKEN', csrf_token);
        xhr.setRequestHeader('Accept', 'application/json');

        if(callback){
            xhr.onreadystatechange = function() {
                if(xhr.readyState == XMLHttpRequest.DONE){
                    callback(xhr);
                }
            };
        }

        if(this.body != null){
            if (this.encoding) xhr.setRequestHeader('Content-type', this.encoding);
            xhr.send(this.body);
        } else {
            xhr.send();
        }
    }
}

class URLEncodedRequest extends AJAXRequest {
    constructor(url, method){
        super(url, method, 'application/x-www-form-urlencoded');

        let csrf_token = document.head.querySelector("[name~=csrf-token][content]").content;
        this.body = "_token=" + csrf_token;
    }

    setParam(key, value){
        let str = key + "=" + value;
        this.body += '&' + str;
    }
}

class FormDataRequest extends AJAXRequest {
    constructor(url) {
        super(url, 'POST', null);
    }

    setParam(key, value) {
        if (!this.body) this.body = new FormData();
        this.body.append(key, value);
    }
}