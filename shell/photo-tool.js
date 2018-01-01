"use strict";
var fs = require("fs");
var path = "./photos/";
fs.readdir(path, function (err, files) {
    if (err) {
        return;
    }
    var arr = [];
    var arrs =[];
  var a = {
    'info' : []
  };
    var date = new Date();
    (function iterator(index) {
        if (index == files.length) {
            fs.writeFile("../source/photo/data.json", JSON.stringify(a, null, "\t"));
            console.log('get img success!');
            return;
        }

        fs.stat(path + files[index], function (err, stats) {
            if (err) {
                return;
            }
            if (stats.isFile()) {
		arrs=files[index].split("_");
		var ym =[];
		ym = arrs[0].split("-");
		var y = ym[0];
                var m = ym[1];
 		var texts =[];
		texts = arrs[1].split(".");
		var text = texts[0];
                a.info.push({"src":"https://raw.githubusercontent.com/ciweigg/blog-back-up/master/shell/photos/"+files[index] ,"y":y ,"m":m ,"text":text});
            }
            iterator(index + 1);
        })
    }(0));
});
