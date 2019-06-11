!function (exports) {
    var Constant = {
        MsgSuccess: 'success',
        MsgFail: 'fail',
        MsgOk: 'ok',
        MsgCancel: 'cancel',
        Results: 'results',
        Camera: {
            Direction: {
                Back: 0,
                Front: 1
            },
            DestinationType: {
                DATA_URL: 0,
                FILE_URI: 1
            },
            EncodingType: {
                JPEG: 0,
                PNG: 1
            }
        }
    };


    var ua = navigator.userAgent.toLowerCase();
    var postMessageEnabled = false;
    if (ua.indexOf('postmessageenabled') != -1) {
        postMessageEnabled = true
    }

    function noop() {
    }

    var callbackIndex = 1;

    var callBackFns = [];

    exports['__YutaAppCallback'] = function (cdId, args) {
        if (typeof args == 'string') {
            args = JSON.parse(args)
        }
        callBackFns[cdId](args);
        delete callBackFns[cdId]
    };


    function invokeWrap(methodName, args, fn) {
        var innerArgs = shadowClone(args);
        fn = fn || noop;
        if ('callbackId' in innerArgs) {
            throw new Error('`callbackId` in args!! should not do this')
        }
        var id = callbackIndex.toString();
        innerArgs['callbackId'] = id;
        callBackFns[id] = fn;。
        callbackIndex++;
        if (window.webkit && window.webkit.messageHandlers) {
            var newObj = {methodName: methodName, args: innerArgs};
            window.webkit.messageHandlers.__YutaJsBridge.postMessage(JSON.stringify(newObj))
        } else {
            __YutaJsBridge.invoke(methodName, JSON.stringify(innerArgs))
        }
    }

    function defaultFailFunc(e) {
        console.warn(e)
    }

    /**
     * @param options:
     * onSuccess:function required
     * onFail:function,
     * args:{}
     */
    function wrapSuccessFailFunc(options) {
        var methodName = options.methodName,
            args = options.args;
        if (!methodName) {
            throw new Error('methodName is required')
        }
        if (typeof options.onSuccess !== 'function') {
            throw new Error('onSuccess is required')
        }
        options.onFail = options.onFail || defaultFailFunc();

        invokeWrap(options.methodName, args, function (args) {
            var msg = args['message'];
            if (msg == Constant.MsgSuccess) {
                options.onSuccess(args[Constant.Results])
            } else if (msg == Constant.MsgFail) {
                options.onFail(args[Constant.Results])
            } else {
                console.warn('unknown message type ')
            }
        })
    }

    function wrapOkCancelFunc(options) {
        var methodName = options.methodName,
            args = options;
        if (!methodName) {
            throw new Error('methodName is required')
        }
        if (typeof options.onOk !== 'function') {
            throw new Error('onOk is required')
        }
        options.onCancel = options.onCancel || defaultFailFunc();

        invokeWrap(options.methodName, args, function (args) {
            var msg = args['message']
            if (msg == Constant.MsgOk) {
                options.onOk()
            } else if (msg == Constant.MsgCancel) {
                options.onCancel()
            } else {
                //TODO emit event
                console.warn('unknown message type ')
            }
        })
    }


    /**
     * Yuta Object
     */
    var Yuta = {
        isWscnApp: ua.indexOf('wscnapp') != -1
    };

    Yuta.Constant = Constant;
    Yuta.Camera = {
        getPicture: function (onSuccess, onFail, options) {
            wrapSuccessFailFunc({
                methodName: 'Yuta.Camera.getPicture',
                onSuccess: onSuccess,
                onFail: onFail,
                args: options
            })
        }
    };

    Yuta.Load = {
        loadImage: function (onSuccess, onFail, options) {
            wrapSuccessFailFunc({
                methodName: 'Yuta.Load.loadImage',
                onSuccess: onSuccess,
                onFail: onFail,
                args: options
            })
        }
    };

    Yuta.WebView = {
        close: function (url) {
            invokeWrap('Yuta.WebView.close', {url: url})
        },
        closeAll: function (url) {
            invokeWrap('Yuta.WebView.closeAll', {url: url})
        },
        load: function (url) {
            invokeWrap('Yuta.WebView.load', {url: url})
        },
        open: function (url) {
            invokeWrap('Yuta.WebView.open', {url: url})
        }
    }


    Yuta.Share = {
        web: function (image, url, title, content, callback) {
            invokeWrap('Yuta.Share.web', {
                image: image,
                url: url,
                title: title,
                content: content
            }, callback)
        },
        image: function (image, title, callback) {
            invokeWrap("Yuta.Share.image", {
                image: image,
                title: title
            }, callback)
        },
        video: function (url, thumb, title, callback) {
            invokeWrap('Yuta.Share.video', {
                url: url,
                thumb: thumb,
                title: title
            }, callback)
        },
        music: function (url, thumb, title, author, callback) {
            invokeWrap('Yuta.Share.music', {
                url: url,
                thumb: thumb,
                title: title,
                author: author
            }, callback)
        }
    };


    Yuta.Device = {
        getProperties: function (callback) {
            invokeWrap('Yuta.Device.getProperties', {}, callback)
        }
    };

    Yuta.Connection = {
        getType: function (callback) {
            invokeWrap('Yuta.Connection.getType', {}, callback)
        }
    };

    Yuta.Dialogs = {
        alert: function (message, okCallBack, title, okButtonName) {
            var args = {message: message};
            if (title) args.title = title;
            if (okButtonName) args.okButtonName = okButtonName
            invokeWrap('Yuta.Dialogs.alert', args, okCallBack)
        },
        //{message:'ok'|'cancel'}
        confirm: function (message, okCallback, title, okButtonName, cancelButtonName, cancelCallback) {
            if (typeof okCallback !== 'function') {
                throw new Error('okCallback(second param) is required')
            }

            var args = {
                methodName: 'Yuta.Dialogs.confirm',
                message: message,
                onOk: okCallback,
                onCancel: cancelCallback
            };
            if (title) args.title = title;
            if (okButtonName) args.okButtonName = okButtonName
            if (cancelButtonName) args.cancelButtonName = cancelButtonName
            wrapOkCancelFunc(args)
        },
        prompt: function (message, okCallback, defaultValue, title, okButtonName, cancelButtonName, cancelCallback) {
            if (typeof okCallback !== 'function') {
                throw new Error('okCallback(second param) is required')
            }

            var args = {
                methodName: 'Yuta.Dialogs.prompt',
                message: message,
                onOk: okCallback,
                onCancel: cancelCallback
            };
            if (defaultValue) args.defaultValue = defaultValue;
            if (title) args.title = title;
            if (okButtonName) args.okButtonName = okButtonName;
            if (cancelButtonName) args.cancelButtonName = cancelButtonName;
            wrapOkCancelFunc(args)
        },
        toast: function (message, duration) {
            var args = {message: message, duration: duration || 1200}
            invokeWrap('Yuta.Dialogs.toast', args)
        }
    }

    Yuta.User = {
        login: function (username, password, callback) {

        }
    }

    exports.Yuta = Yuta;


    function shadowClone(obj) {
        if (typeof obj !== 'object') {
            return {}
        }
        var cloneObj = {};
        for (var i in obj) {
            if (obj.hasOwnProperty(i)) {
                cloneObj[i] = obj[i]
            }
        }
        return cloneObj
    }

}(window);
