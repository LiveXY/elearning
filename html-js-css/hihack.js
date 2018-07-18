(function(g) {
	var b = window.location.href,
	b = encodeURIComponent(b),
	c = window.navigator.userAgent.toLocaleLowerCase(),
	h = "tel:|chebada.com|weixin|qq.com|sms:12306|ly.com|tongcheng|117go.com|40017.cn|17usoft.com|17u.com|17u.cn|cnzz.com|baidu.com|yiqiyou.com|upaiyun|fraudmetrix|360.cn|360.com|tctravel://|tctclient://|data:image";
	var e = Math.floor(Math.random() * 1000000000000),
	d = {},
	f = document.location.protocol == "https:";
	setTimeout(function() {
		d = {
			img: document.getElementsByTagName("img"),
			link: document.getElementsByTagName("a"),
			script: document.getElementsByTagName("script"),
			iframe: document.getElementsByTagName("iframe")
		}
	},
	1500);
	var a = {
		getPlatform: function() {
			var i = "touch";
			if (c.indexOf("micromessenger") > -1) {
				i = "wechat"
			} else {
				if (c.indexOf("tctravel") > -1) {
					i = "app"
				} else {
					if ((c.indexOf("qq/") > -1) && (c.indexOf("qqbrowser") > -1)) {
						i = "qq"
					}
				}
			}
			return i
		},
		getMatchLink: function(n) {
			var l, k, j = [],
			p;
			switch (n) {
			case "link":
				l = document.links;
				break;
			case "img":
				l = document.images;
				break;
			case "script":
				l = document.scripts;
				break;
			case "iframe":
				l = document.getElementsByTagName("iframe");
				break;
			default:
				break
			}
			for (var m = 0,
			o = l.length; m < o; m++) {
				if ( !! (n == "link" ? l[m].href: l[m].src).match(/\S/)) {
					if (! (n == "link" ? l[m].href: l[m].src).match(/javascript|localhost|file:\/\/|10(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){3}|172\.([1][6-9]|[2]\d|3[01])(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}|192\.168(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}/)) {
						p = {
							type: n,
							link: n == "link" ? l[m].href: l[m].src
						};
						j.push(p)
					}
				}
			}
			return j
		},
		mElement: function() {
			var t = this,
			m = [],
			k,
			o,
			n,
			w,
			j = [],
			v = t.getMatchLink("link"),
			p = t.getMatchLink("img"),
			l = t.getMatchLink("script"),
			u = t.getMatchLink("iframe");
			k = v.concat(p);
			o = l.concat(u);
			n = k.concat(o);
			var s = h + (t.whiteList ? "|" + t.whiteList: "");
			for (var q = 0,
			r = n.length; q < r; q++) {
				w = n[0];
				if (!w.link.toLocaleLowerCase().match(s)) {
					t.removeError && t.removeDom(w.type, w.link);
					m.push(JSON.stringify(w))
				}
				if (f && w.link.toLocaleLowerCase().match(/^http:/i)) {
					j.push(JSON.stringify(w))
				}
				n.shift();
				if (m.length > 0 && m.length % 8 === 0) {
					t.hijackStorage(m);
					m = []
				}
				if (j.length > 0 && j.length % 8 === 0) {
					t.httpStorage(j);
					j = []
				}
			}
			if (m.length > 0) {
				t.hijackStorage(m)
			}
			if (j.length > 0) {
				t.httpStorage(j)
			}
		},
		encodeStr: function(i) {
			i = i ? encodeURIComponent(i) : "";
			return i
		},
		hijackStorage: function(m) {
			var r = this,
			k = r.removeError ? true: false,
			i = r.encodeStr(r.projectTag),
			o = r.encodeStr(r.pageName),
			j = r.encodeStr(r.platform),
			n = r.encodeStr(b),
			q = r.encodeStr("[" + m.toString() + "]");
			var l = new Image(),
			p = "https:" == document.location.protocol ? "https://vstlog.17usoft.com/monitor/__h5hm.gif": "http://vstlog.17usoft.com/monitor/__h5hm.gif";
			p = p + "?staType=hijack&jc_projectTag=" + i + "&jc_pageName=" + o + "&jc_platform=" + j + "&jc_locationUrl=" + n + "&jc_remove=" + k + "&jc_uId=" + e + "&jc_gather=" + q;
			l.src = p
		},
		httpStorage: function(k) {
			var m = this,
			o = m.encodeStr(m.projectTag),
			j = m.encodeStr(m.pageName),
			n = m.encodeStr(b),
			p = m.encodeStr("[" + k.toString() + "]");
			var l = new Image(),
			i = "https://vstlog.17usoft.com/monitor/__h5hm.gif?staType=httpsInfo&projectTag=" + o + "&pageName=" + j + "&locationUrl=" + n + "&httpArr=" + p;
			l.src = i
		},
		resetSetAttribute: function() {
			var j = this,
			i = h + (j.whiteList ? "|" + j.whiteList: ""),
			k = {};
			var l = window.Element.prototype.setAttribute;
			window.Element.prototype.setAttribute = function(n, o) {
				var p = this.tagName.toLowerCase(),
				m = "",
				q = [];
				if (n == "src" || n == "href") {
					if (o.match(/^http/i) && !o.match(i) && o.match(/\S/)) {
						if ( !! p.match(/img|script|iframe|a/i)) {
							k = {
								type: p,
								link: o
							};
							q.push(JSON.stringify(k));
							j.hijackStorage(q)
						}
						return
					}
				}
				l.apply(this, arguments)
			}
		},
		bindObserver: function() {
			var m = this,
			j = h + (m.whiteList ? "|" + m.whiteList: ""),
			o,
			k;
			try {
				var l = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
				var i = new l(function(q) {
					var p = [],
					t = [];
					q.forEach(function(v) {
						var u = v.addedNodes;
						for (var w = 0; w < u.length; w++) {
							var x = u[w];
							if (x.tagName === "SCRIPT" || x.tagName === "IFRAME" || x.tagName === "IMG") {
								if (x.tagName === "IFRAME" && x.srcdoc) {
									x.parentNode.removeChild(x)
								} else {
									if (x.src) {
										if (x.src.match(/^http/i) && !x.src.match(/javascript|localhost|file:\/\/|10(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){3}|172\.([1][6-9]|[2]\d|3[01])(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}|192\.168(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}/)) {
											if (!x.src.match(j) && x.src.match(/\S/)) {
												x.parentNode.removeChild(x);
												o = {
													type: x.tagName.toLocaleLowerCase(),
													link: x.src
												};
												p.push(JSON.stringify(o))
											}
										}
									}
								}
							} else {
								if (x.tagName === "A" && x.href) {
									if (x.href.match(/^http/i) && !x.href.match(/javascript|localhost|file:\/\/|10(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){3}|172\.([1][6-9]|[2]\d|3[01])(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}|192\.168(\.([2][0-4]\d|[2][5][0-5]|[01]?\d?\d)){2}/)) {
										if (!x.href.match(j) && x.href.match(/\S/)) {
											x.parentNode.removeChild(x);
											o = {
												type: "link",
												link: x.href
											};
											p.push(JSON.stringify(o))
										}
									}
								}
							}
						}
					});
					for (var s = 0,
					r = p.length; s < r; s++) {
						k = p[0];
						t.push(k);
						p.shift();
						if (t.length > 0 && t.length % 8 === 0) {
							m.hijackStorage(t);
							t = []
						}
					}
					if (t.length > 0) {
						m.hijackStorage(t)
					}
				});
				i.observe(document, {
					subtree: true,
					childList: true
				})
			} catch(n) {}
		},
		removeDom: function(k, n) {
			var m, l = [];
			switch (k) {
			case "link":
				m = "href";
				l = d.link;
				break;
			case "img":
				m = "src";
				l = d.img;
				break;
			case "script":
				m = "src";
				l = d.script;
				break;
			case "iframe":
				m = "src";
				l = d.iframe;
				break;
			default:
				break
			}
			for (var j = 0; j < l.length; j++) {
				if ((m == "href" && l[j].href == n) || (m == "src" && l[j].src == n)) {
					l[j].parentNode.removeChild(l[j])
				}
			}
		},
		onLoad: function(i) {
			if ((c.indexOf("msie") >= 0) && (c.indexOf("opera") < 0)) {
				window.attachEvent("onload",
				function() {
					window.detachEvent("onload", i);
					i()
				})
			} else {
				window.addEventListener("load",
				function() {
					window.removeEventListener("load", i, false);
					i()
				},
				false)
			}
			window.addEventListener("load",
			function() {
				window.removeEventListener("load", i, false);
				i()
			},
			false)
		},
		init: function(j) {
			var i = this;
			if (!j.projectTag) {
				return
			}
			i.whiteList = j.whiteList || "";
			i.projectTag = j.projectTag;
			i.pageName = j.pageName || document.title || "";
			i.platform = j.platform || i.getPlatform();
			i.removeError = j.removeError || false;
			i.onLoad(function() {
				setTimeout(function() {
					i.mElement();
					i.resetSetAttribute();
					i.bindObserver()
				},
				1500)
			})
		}
	};
	g.fed_hijack = a
})(window);

/*
fed_hijack.init({
	whiteList:"ly.com|17u.cn|17u.com|tctravel://|data:image|baidu.com|bdstatic.com|bdimg.com|pavo.elongstatic.com",
	projectTag:"jiudian",
	removeError:true,
});
*/