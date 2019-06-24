!function(r){"use strict";function n(r,n,t){return t.a=r,t.f=n,t}function e(t){return n(2,t,function(n){return function(r){return t(n,r)}})}function t(e){return n(3,e,function(t){return function(n){return function(r){return e(t,n,r)}}})}function u(u){return n(4,u,function(e){return function(t){return function(n){return function(r){return u(e,t,n,r)}}}})}function a(a){return n(5,a,function(u){return function(e){return function(t){return function(n){return function(r){return a(u,e,t,n,r)}}}}})}function i(i){return n(6,i,function(a){return function(u){return function(e){return function(t){return function(n){return function(r){return i(a,u,e,t,n,r)}}}}}})}function f(c){return n(9,c,function(o){return function(f){return function(i){return function(a){return function(u){return function(e){return function(t){return function(n){return function(r){return c(o,f,i,a,u,e,t,n,r)}}}}}}}}})}function h(r,n,t){return 2===r.a?r.f(n,t):r(n)(t)}function $(r,n,t,e){return 3===r.a?r.f(n,t,e):r(n)(t)(e)}function d(r,n,t,e,u){return 4===r.a?r.f(n,t,e,u):r(n)(t)(e)(u)}function s(r,n,t,e,u,a){return 5===r.a?r.f(n,t,e,u,a):r(n)(t)(e)(u)(a)}function b(r,n,t,e,u,a,i){return 6===r.a?r.f(n,t,e,u,a,i):r(n)(t)(e)(u)(a)(i)}function o(r,n,t,e,u,a,i,f,o,c){return 9===r.a?r.f(n,t,e,u,a,i,f,o,c):r(n)(t)(e)(u)(a)(i)(f)(o)(c)}var l={$:0};function g(r,n){return{$:1,a:r,b:n}}var c=e(g);function m(r){for(var n=l,t=r.length;t--;)n=g(r[t],n);return n}function v(r){for(var n=[];r.b;r=r.b)n.push(r.a);return n}function p(r,n,t){if("object"!=typeof r)return r===n?0:r<n?-1:1;if(!r.$)return(t=p(r.a,n.a))?t:(t=p(r.b,n.b))?t:p(r.c,n.c);for(;r.b&&n.b&&!(t=p(r.a,n.a));r=r.b,n=n.b);return t||(r.b?1:n.b?-1:0)}var y=0;function k(r,n){return{a:r,b:n}}function w(r,n){var t={};for(var e in r)t[e]=r[e];for(var e in n)t[e]=n[e];return t}function A(r,n){if("string"==typeof r)return r+n;if(!r.b)return n;var t=g(r.a,n);r=r.b;for(var e=t;r.b;r=r.b)e=e.b=g(r.a,n);return t}var _=t(function(r,n,t){for(var e=Array(r),u=0;u<r;u++)e[u]=t(n+u);return e}),j=e(function(r,n){for(var t=Array(r),e=0;e<r&&n.b;e++)t[e]=n.a,n=n.b;return t.length=e,k(t,n)});function T(r){throw Error("https://github.com/elm/core/blob/1.0.0/hints/"+r+".md")}var E=e(function(r,n){return r+n}),N=Math.cos,L=Math.sin;var x=Math.ceil,C=Math.floor,M=Math.round,q=Math.log;var O=e(function(r,n){return n.join(r)});function z(r){return r+""}var J=e(function(r,n){return R(r,P(n))});function R(r,n){switch(r.$){case 3:return"boolean"==typeof n?mn(n):F("a BOOL",n);case 2:return"number"!=typeof n?F("an INT",n):-2147483647<n&&n<2147483647&&(0|n)===n?mn(n):!isFinite(n)||n%1?F("an INT",n):mn(n);case 4:return"number"==typeof n?mn(n):F("a FLOAT",n);case 6:return"string"==typeof n?mn(n):n instanceof String?mn(n+""):F("a STRING",n);case 9:return null===n?mn(r.c):F("null",n);case 5:return mn(D(n));case 7:return Array.isArray(n)?S(r.b,n,m):F("a LIST",n);case 8:return Array.isArray(n)?S(r.b,n,Y):F("an ARRAY",n);case 10:var t=r.d;if("object"!=typeof n||null===n||!(t in n))return F("an OBJECT with a field named `"+t+"`",n);var e=R(r.b,n[t]);return Ur(e)?e:gn(h(yn,t,e.a));case 11:var u=r.e;if(!Array.isArray(n))return F("an ARRAY",n);if(n.length<=u)return F("a LONGER array. Need index "+u+" but only see "+n.length+" entries",n);e=R(r.b,n[u]);return Ur(e)?e:gn(h(kn,u,e.a));case 12:if("object"!=typeof n||null===n||Array.isArray(n))return F("an OBJECT",n);var a=l;for(var i in n)if(n.hasOwnProperty(i)){e=R(r.b,n[i]);if(!Ur(e))return gn(h(yn,i,e.a));a=g(k(i,e.a),a)}return mn(fn(a));case 13:for(var f=r.f,o=r.g,c=0;c<o.length;c++){e=R(o[c],n);if(!Ur(e))return e;f=f(e.a)}return mn(f);case 14:e=R(r.b,n);return Ur(e)?R(r.h(e.a),n):e;case 15:for(var v=l,s=r.g;s.b;s=s.b){e=R(s.a,n);if(Ur(e))return e;v=g(e.a,v)}return gn(wn(fn(v)));case 1:return gn(h(pn,r.a,D(n)));case 0:return mn(r.a)}}function S(r,n,t){for(var e=n.length,u=Array(e),a=0;a<e;a++){var i=R(r,n[a]);if(!Ur(i))return gn(h(kn,a,i.a));u[a]=i.a}return mn(t(u))}function Y(n){return h($n,n.length,function(r){return n[r]})}function F(r,n){return gn(h(pn,"Expecting "+r,D(n)))}function B(r,n){if(r===n)return!0;if(r.$!==n.$)return!1;switch(r.$){case 0:case 1:return r.a===n.a;case 3:case 2:case 4:case 6:case 5:return!0;case 9:return r.c===n.c;case 7:case 8:case 12:return B(r.b,n.b);case 10:return r.d===n.d&&B(r.b,n.b);case 11:return r.e===n.e&&B(r.b,n.b);case 13:return r.f===n.f&&I(r.g,n.g);case 14:return r.h===n.h&&B(r.b,n.b);case 15:return I(r.g,n.g)}}function I(r,n){var t=r.length;if(t!==n.length)return!1;for(var e=0;e<t;e++)if(!B(r[e],n[e]))return!1;return!0}function D(r){return r}function P(r){return r}var X=t(function(r,n,t){return t[r]=P(n),t});D(null);function G(r){return{$:0,a:r}}function H(r){return{$:2,b:r,c:null}}var W=e(function(r,n){return{$:3,b:r,d:n}});var K=0;function Q(r){var n={$:0,e:K++,f:r,g:null,h:[]};return nr(n),n}function U(n){return H(function(r){r(G(Q(n)))})}function V(r,n){r.h.push(n),nr(r)}var Z=!1,rr=[];function nr(r){if(rr.push(r),!Z){for(Z=!0;r=rr.shift();)tr(r);Z=!1}}function tr(n){for(;n.f;){var r=n.f.$;if(0===r||1===r){for(;n.g&&n.g.$!==r;)n.g=n.g.i;if(!n.g)return;n.f=n.g.b(n.f.a),n.g=n.g.i}else{if(2===r)return void(n.f.c=n.f.b(function(r){n.f=r,nr(n)}));if(5===r){if(0===n.h.length)return;n.f=n.f.b(n.h.shift())}else n.g={$:3===r?0:1,b:n.f.b,i:n.g},n.f=n.f.d}}}function er(r,n,t,e,u,a){var i=h(J,r,D(n?n.flags:void 0));Ur(i)||T(2);var f={},o=(i=t(i.a)).a,c=a(s,o),v=function(r,n){var t;for(var e in ur){var u=ur[e];u.a&&((t=t||{})[e]=u.a(e,n)),r[e]=ar(u,n)}return t}(f,s);function s(r,n){c(o=(i=h(e,r,o)).a,n),cr(f,i.b,u(o))}return cr(f,i.b,u(o)),v?{ports:v}:{}}var ur={};function ar(r,n){var e={g:n,h:void 0},u=r.c,a=r.d,i=r.e,f=r.f;function o(t){return h(W,o,{$:5,b:function(r){var n=r.a;return 0===r.$?$(a,e,n,t):i&&f?d(u,e,n.i,n.j,t):$(u,e,i?n.i:n.j,t)}})}return e.h=Q(h(W,o,r.b))}var ir=e(function(n,t){return H(function(r){n.g(t),r(G(y))})});function fr(n){return function(r){return{$:1,k:n,l:r}}}function or(r){return{$:2,m:r}}function cr(r,n,t){var e={};for(var u in vr(!0,n,e,null),vr(!1,t,e,null),r)V(r[u],{$:"fx",a:e[u]||{i:l,j:l}})}function vr(r,n,t,e){switch(n.$){case 1:var u=n.k,a=function(r,n,t,e){function u(r){for(var n=t;n;n=n.q)r=n.p(r);return r}return h(r?ur[n].e:ur[n].f,u,e)}(r,u,e,n.l);return void(t[u]=function(r,n,t){return t=t||{i:l,j:l},r?t.i=g(n,t.i):t.j=g(n,t.j),t}(r,a,t[u]));case 2:for(var i=n.m;i.b;i=i.b)vr(r,i.a,t,e);return;case 3:return void vr(r,n.o,t,{p:n.n,q:e})}}var sr,br="undefined"!=typeof document?document:{};function lr(r,n){r.appendChild(n)}function dr(r){return{$:0,a:r}}var hr=e(function(a,i){return e(function(r,n){for(var t=[],e=0;n.b;n=n.b){var u=n.a;e+=u.b||0,t.push(u)}return e+=t.length,{$:1,c:i,d:pr(r),e:t,f:a,b:e}})})(void 0);e(function(a,i){return e(function(r,n){for(var t=[],e=0;n.b;n=n.b){var u=n.a;e+=u.b.b||0,t.push(u)}return e+=t.length,{$:2,c:i,d:pr(r),e:t,f:a,b:e}})})(void 0);var $r=e(function(r,n){return{$:"a2",n:r,o:n}}),gr=e(function(r,n){return{$:"a3",n:r,o:n}});var mr;function pr(r){for(var n={};r.b;r=r.b){var t=r.a,e=t.$,u=t.n,a=t.o;if("a2"!==e){var i=n[e]||(n[e]={});"a3"===e&&"class"===u?yr(i,u,a):i[u]=a}else"className"===u?yr(n,u,P(a)):n[u]=P(a)}return n}function yr(r,n,t){var e=r[n];r[n]=e?e+" "+t:t}function kr(r,n){var t=r.$;if(5===t)return kr(r.k||(r.k=r.m()),n);if(0===t)return br.createTextNode(r.a);if(4===t){for(var e=r.k,u=r.j;4===e.$;)"object"!=typeof u?u=[u,e.j]:u.push(e.j),e=e.k;var a={j:u,p:n};return(i=kr(e,a)).elm_event_node_ref=a,i}if(3===t)return wr(i=r.h(r.g),n,r.d),i;var i=r.f?br.createElementNS(r.f,r.c):br.createElement(r.c);sr&&"a"==r.c&&i.addEventListener("click",sr(i)),wr(i,n,r.d);for(var f=r.e,o=0;o<f.length;o++)lr(i,kr(1===t?f[o]:f[o].b,n));return i}function wr(r,n,t){for(var e in t){var u=t[e];"a1"===e?Ar(r,u):"a0"===e?Tr(r,n,u):"a3"===e?_r(r,u):"a4"===e?jr(r,u):("value"!==e||"checked"!==e||r[e]!==u)&&(r[e]=u)}}function Ar(r,n){var t=r.style;for(var e in n)t[e]=n[e]}function _r(r,n){for(var t in n){var e=n[t];e?r.setAttribute(t,e):r.removeAttribute(t)}}function jr(r,n){for(var t in n){var e=n[t],u=e.f,a=e.o;a?r.setAttributeNS(u,t,a):r.removeAttributeNS(u,t)}}function Tr(r,n,t){var e=r.elmFs||(r.elmFs={});for(var u in t){var a=t[u],i=e[u];if(a){if(i){if(i.q.$===a.$){i.q=a;continue}r.removeEventListener(u,i)}i=Er(n,a),r.addEventListener(u,i,mr&&{passive:qt(a)<2}),e[u]=i}else r.removeEventListener(u,i),e[u]=void 0}}try{window.addEventListener("t",null,Object.defineProperty({},"passive",{get:function(){mr=!0}}))}catch(r){}function Er(v,r){function s(r){var n=s.q,t=R(n.a,r);if(Ur(t)){for(var e,u=qt(n),a=t.a,i=u?u<3?a.a:a.M:a,f=1==u?a.b:3==u&&a.a7,o=(f&&r.stopPropagation(),(2==u?a.b:3==u&&a.a2)&&r.preventDefault(),v);e=o.j;){if("function"==typeof e)i=e(i);else for(var c=e.length;c--;)i=e[c](i);o=o.p}o(i,f)}}return s.q=r,s}function Nr(r,n){return r.$==n.$&&B(r.a,n.a)}function Lr(r,n){var t=[];return Cr(r,n,t,0),t}function xr(r,n,t,e){var u={$:n,r:t,s:e,t:void 0,u:void 0};return r.push(u),u}function Cr(r,n,t,e){if(r!==n){var u=r.$,a=n.$;if(u!==a){if(1!==u||2!==a)return void xr(t,0,e,n);n=function(r){for(var n=r.e,t=n.length,e=Array(t),u=0;u<t;u++)e[u]=n[u].b;return{$:1,c:r.c,d:r.d,e:e,f:r.f,b:r.b}}(n),a=1}switch(a){case 5:for(var i=r.l,f=n.l,o=i.length,c=o===f.length;c&&o--;)c=i[o]===f[o];if(c)return void(n.k=r.k);n.k=n.m();var v=[];return Cr(r.k,n.k,v,0),void(0<v.length&&xr(t,1,e,v));case 4:for(var s=r.j,b=n.j,l=!1,d=r.k;4===d.$;)l=!0,"object"!=typeof s?s=[s,d.j]:s.push(d.j),d=d.k;for(var h=n.k;4===h.$;)l=!0,"object"!=typeof b?b=[b,h.j]:b.push(h.j),h=h.k;return l&&s.length!==b.length?void xr(t,0,e,n):((l?function(r,n){for(var t=0;t<r.length;t++)if(r[t]!==n[t])return!1;return!0}(s,b):s===b)||xr(t,2,e,b),void Cr(d,h,t,e+1));case 0:return void(r.a!==n.a&&xr(t,3,e,n.a));case 1:return void Mr(r,n,t,e,Or);case 2:return void Mr(r,n,t,e,zr);case 3:if(r.h!==n.h)return void xr(t,0,e,n);var $=qr(r.d,n.d);$&&xr(t,4,e,$);var g=n.i(r.g,n.g);return void(g&&xr(t,5,e,g))}}}function Mr(r,n,t,e,u){if(r.c===n.c&&r.f===n.f){var a=qr(r.d,n.d);a&&xr(t,4,e,a),u(r,n,t,e)}else xr(t,0,e,n)}function qr(r,n,t){var e;for(var u in r)if("a1"!==u&&"a0"!==u&&"a3"!==u&&"a4"!==u)if(u in n){var a=r[u],i=n[u];a===i&&"value"!==u&&"checked"!==u||"a0"===t&&Nr(a,i)||((e=e||{})[u]=i)}else(e=e||{})[u]=t?"a1"===t?"":"a0"===t||"a3"===t?void 0:{f:r[u].f,o:void 0}:"string"==typeof r[u]?"":null;else{var f=qr(r[u],n[u]||{},u);f&&((e=e||{})[u]=f)}for(var o in n)o in r||((e=e||{})[o]=n[o]);return e}function Or(r,n,t,e){var u=r.e,a=n.e,i=u.length,f=a.length;f<i?xr(t,6,e,{v:f,i:i-f}):i<f&&xr(t,7,e,{v:i,e:a});for(var o=i<f?i:f,c=0;c<o;c++){var v=u[c];Cr(v,a[c],t,++e),e+=v.b||0}}function zr(r,n,t,e){for(var u=[],a={},i=[],f=r.e,o=n.e,c=f.length,v=o.length,s=0,b=0,l=e;s<c&&b<v;){var d=(T=f[s]).a,h=(E=o[b]).a,$=T.b,g=E.b;if(d!==h){var m=f[s+1],p=o[b+1];if(m)var y=m.a,k=m.b,w=h===y;if(p)var A=p.a,_=p.b,j=d===A;if(j&&w)Cr($,_,u,++l),Rr(a,u,d,g,b,i),l+=$.b||0,Sr(a,u,d,k,++l),l+=k.b||0,s+=2,b+=2;else if(j)l++,Rr(a,u,h,g,b,i),Cr($,_,u,l),l+=$.b||0,s+=1,b+=2;else if(w)Sr(a,u,d,$,++l),l+=$.b||0,Cr(k,g,u,++l),l+=k.b||0,s+=2,b+=1;else{if(!m||y!==A)break;Sr(a,u,d,$,++l),Rr(a,u,h,g,b,i),l+=$.b||0,Cr(k,_,u,++l),l+=k.b||0,s+=2,b+=2}}else Cr($,g,u,++l),l+=$.b||0,s++,b++}for(;s<c;){var T;Sr(a,u,(T=f[s]).a,$=T.b,++l),l+=$.b||0,s++}for(;b<v;){var E,N=N||[];Rr(a,u,(E=o[b]).a,E.b,void 0,N),b++}(0<u.length||0<i.length||N)&&xr(t,8,e,{w:u,x:i,y:N})}var Jr="_elmW6BL";function Rr(r,n,t,e,u,a){var i=r[t];if(!i)return a.push({r:u,A:i={c:0,z:e,r:u,s:void 0}}),void(r[t]=i);if(1===i.c){a.push({r:u,A:i}),i.c=2;var f=[];return Cr(i.z,e,f,i.r),i.r=u,void(i.s.s={w:f,A:i})}Rr(r,n,t+Jr,e,u,a)}function Sr(r,n,t,e,u){var a=r[t];if(a){if(0===a.c){a.c=2;var i=[];return Cr(e,a.z,i,u),void xr(n,9,u,{w:i,A:a})}Sr(r,n,t+Jr,e,u)}else{var f=xr(n,9,u,void 0);r[t]={c:1,z:e,r:u,s:f}}}function Yr(r,n,t,e){!function r(n,t,e,u,a,i,f){var o=e[u];var c=o.r;for(;c===a;){var v=o.$;if(1===v)Yr(n,t.k,o.s,f);else if(8===v){o.t=n,o.u=f;var s=o.s.w;0<s.length&&r(n,t,s,0,a,i,f)}else if(9===v){o.t=n,o.u=f;var b=o.s;if(b){b.A.s=n;var s=b.w;0<s.length&&r(n,t,s,0,a,i,f)}}else o.t=n,o.u=f;if(!(o=e[++u])||(c=o.r)>i)return u}var l=t.$;if(4===l){for(var d=t.k;4===d.$;)d=d.k;return r(n,d,e,u,a+1,i,n.elm_event_node_ref)}var h=t.e;var $=n.childNodes;for(var g=0;g<h.length;g++){var m=1===l?h[g]:h[g].b,p=++a+(m.b||0);if(a<=c&&c<=p&&(u=r($[g],m,e,u,a,p,f),!(o=e[u])||(c=o.r)>i))return u;a=p}return u}(r,n,t,0,0,n.b,e)}function Fr(r,n,t,e){return 0===t.length?r:(Yr(r,n,t,e),Br(r,t))}function Br(r,n){for(var t=0;t<n.length;t++){var e=n[t],u=e.t,a=Ir(u,e);u===r&&(r=a)}return r}function Ir(r,n){switch(n.$){case 0:return function(r,n,t){var e=r.parentNode,u=kr(n,t);u.elm_event_node_ref||(u.elm_event_node_ref=r.elm_event_node_ref);e&&u!==r&&e.replaceChild(u,r);return u}(r,n.s,n.u);case 4:return wr(r,n.u,n.s),r;case 3:return r.replaceData(0,r.length,n.s),r;case 1:return Br(r,n.s);case 2:return r.elm_event_node_ref?r.elm_event_node_ref.j=n.s:r.elm_event_node_ref={j:n.s,p:n.u},r;case 6:for(var t=n.s,e=0;e<t.i;e++)r.removeChild(r.childNodes[t.v]);return r;case 7:for(var u=(t=n.s).e,a=r.childNodes[e=t.v];e<u.length;e++)r.insertBefore(kr(u[e],n.u),a);return r;case 9:if(!(t=n.s))return r.parentNode.removeChild(r),r;var i=t.A;return void 0!==i.r&&r.parentNode.removeChild(r),i.s=Br(r,t.w),r;case 8:return function(r,n){var t=n.s,e=function(r,n){if(!r)return;for(var t=br.createDocumentFragment(),e=0;e<r.length;e++){var u=r[e],a=u.A;lr(t,2===a.c?a.s:kr(a.z,n.u))}return t}(t.y,n);r=Br(r,t.w);for(var u=t.x,a=0;a<u.length;a++){var i=u[a],f=i.A,o=2===f.c?f.s:kr(f.z,n.u);r.insertBefore(o,r.childNodes[i.r])}e&&lr(r,e);return r}(r,n);case 5:return n.s(r);default:T(10)}}function Dr(r){if(3===r.nodeType)return dr(r.textContent);if(1!==r.nodeType)return dr("");for(var n=l,t=r.attributes,e=t.length;e--;){var u=t[e];n=g(h(gr,u.name,u.value),n)}var a=r.tagName.toLowerCase(),i=l,f=r.childNodes;for(e=f.length;e--;)i=g(Dr(f[e]),i);return $(hr,a,n,i)}var Pr=u(function(n,r,t,f){return er(r,f,n.cm,n.cY,n.cR,function(e,r){var u=n.c_,a=f.node,i=Dr(a);return Gr(r,function(r){var n=u(r),t=Lr(i,n);a=Fr(a,i,t,e),i=n})})}),Xr="undefined"!=typeof requestAnimationFrame?requestAnimationFrame:function(r){setTimeout(r,1e3/60)};function Gr(t,e){e(t);var u=0;function a(){u=1===u?0:(Xr(a),e(t),1)}return function(r,n){t=r,n?(e(t),2===u&&(u=1)):(0===u&&Xr(a),u=2)}}var Hr={addEventListener:function(){},removeEventListener:function(){}};"undefined"!=typeof document&&document,"undefined"!=typeof window&&window;var Wr,Kr=c,Qr=C,Ur=function(r){return!r.$},Vr=u(function(r,n,t,e){return{$:0,a:r,b:n,c:t,d:e}}),Zr=x,rn=e(function(r,n){return q(n)/q(r)}),nn=Zr(h(rn,2,32)),tn=[],en=d(Vr,0,nn,tn,tn),un=j,an=t(function(r,n,t){for(;;){if(!t.b)return n;var e=t.b,u=r,a=h(r,t.a,n);r=u,n=a,t=e}}),fn=function(r){return $(an,Kr,l,r)},on=e(function(r,n){for(;;){var t=h(un,32,r),e=t.b,u=h(Kr,{$:0,a:t.a},n);if(!e.b)return fn(u);r=e,n=u}}),cn=e(function(r,n){for(;;){var t=Zr(n/32);if(1===t)return h(un,32,r).a;r=h(on,r,l),n=t}}),vn=E,sn=e(function(r,n){return 0<p(r,n)?r:n}),bn=function(r){return r.length},ln=e(function(r,n){if(n.k){var t=32*n.k,e=Qr(h(rn,32,t-1)),u=r?fn(n.o):n.o,a=h(cn,u,n.k);return d(Vr,bn(n.n)+t,h(sn,5,e*nn),a,n.n)}return d(Vr,bn(n.n),nn,tn,n.n)}),dn=_,hn=a(function(r,n,t,e,u){for(;;){if(n<0)return h(ln,!1,{o:e,k:t/32|0,n:u});var a={$:1,a:$(dn,32,n,r)};r=r,n=n-32,t=t,e=h(Kr,a,e),u=u}}),$n=e(function(r,n){if(0<r){var t=r%32;return s(hn,n,r-t-32,r,l,$(dn,t,r-t,n))}return en}),gn=function(r){return{$:1,a:r}},mn=function(r){return{$:0,a:r}},pn=e(function(r,n){return{$:3,a:r,b:n}}),yn=e(function(r,n){return{$:0,a:r,b:n}}),kn=e(function(r,n){return{$:1,a:r,b:n}}),wn=function(r){return{$:2,a:r}},An=z,_n=e(function(r,n){return h(O,r,v(n))}),jn=or(l),Tn=e(function(r,n){return{$:0,a:r,b:n}}),En=function(r){var n=r.b;return h(Tn,1664525*r.a+n>>>0,n)},Nn=or(l),Ln=e(function(r,n){return k(n.a,r(n.b))}),xn=e(function(r,n){return k(h(Ln,vn(1),n),jn)}),Cn=function(r){return{$:1,a:r}},Mn=function(r){return{$:2,a:r}},qn=t(function(r,n,t){return{$:0,a:r,b:n,c:t}}),On=t(function(r,n,t){return $(qn,r,n,t)}),zn={$:0},Jn=e(function(r,n){return{$:3,a:r,b:n}}),Rn=function(r){return{$:2,a:r}},Sn=e(function(r,n){var t=k(r,n);r:for(;;)switch(t.b.$){case 3:var e=t.b;return h(Jn,e.a,e.b);case 1:switch(t.a.$){case 1:return Cn(t.b.a);case 2:return h(Jn,t.b.a,t.a.a);case 3:var u=t.a;return h(Jn,t.b.a,u.b);default:break r}case 2:switch(t.a.$){case 2:return Rn(t.b.a);case 1:return h(Jn,t.a.a,t.b.a);case 3:var a=t.a;return h(Jn,a.a,t.b.a);default:break r}default:if(t.a.$){return t.a}break r}return t.b}),Yn=function(r){return r},Fn=e(function(r,n){return $(an,e(function(r,n){var t=n;switch(r.$){case 0:return w(t,{J:h(Kr,r.a,t.J)});case 1:return w(t,{J:$(an,Kr,t.J,r.a)});case 3:return w(t,{Y:(0,r.a)(t.Y)});default:return w(t,{X:h(Sn,t.X,r.a)})}}),n,r)}),Bn=e(function(r,n){return h(Fn,r,{J:l,X:zn,Y:(t=n,{$:1,a:t})});var t}),In=e(function(r,n){return D($(an,function(t){return e(function(r,n){return n.push(P(t(r))),n})}(r),[],n))}),Dn=function(r){return D($(an,e(function(r,n){return $(X,r.a,r.b,n)}),{},r))},Pn=D,Xn=e(function(r,n){return Dn(m([k("type",Pn("function")),k("name",Pn(r)),k("args",h(In,Yn,n))]))}),Gn=D,Hn=a(function(r,n,t,e,u){return h(Xn,"arcTo",m([Gn(r),Gn(n),Gn(t),Gn(e),Gn(u)]))}),Wn=i(function(r,n,t,e,u,a){return h(Xn,"bezierCurveTo",m([Gn(r),Gn(n),Gn(t),Gn(e),Gn(u),Gn(a)]))}),Kn=e(function(r,n){return h(Xn,"lineTo",m([Gn(r),Gn(n)]))}),Qn=e(function(r,n){return h(Xn,"moveTo",m([Gn(r),Gn(n)]))}),Un=u(function(r,n,t,e){return h(Xn,"quadraticCurveTo",m([Gn(r),Gn(n),Gn(t),Gn(e)]))}),Vn=e(function(r,n){switch(r.$){case 0:var t=r.a,e=r.b;return h(Kr,s(Hn,t.a,t.b,e.a,e.b,r.c),n);case 1:var u=r.a,a=r.b,i=r.c;return h(Kr,b(Wn,u.a,u.b,a.a,a.b,i.a,i.b),n);case 2:var f=r.a;return h(Kr,h(Kn,f.a,f.b),n);case 3:var o=r.a;return h(Kr,h(Qn,o.a,o.b),n);default:var c=r.a,v=r.b;return h(Kr,d(Un,c.a,c.b,v.a,v.b),n)}}),Zn=D,rt=i(function(r,n,t,e,u,a){return h(Xn,"arc",m([Gn(r),Gn(n),Gn(t),Gn(e),Gn(u),Zn(a)]))}),nt=t(function(r,n,t){return b(rt,r,n,t,0,6.283185307179586,!1)}),tt=u(function(r,n,t,e){return h(Xn,"rect",m([Gn(r),Gn(n),Gn(t),Gn(e)]))}),et=N,ut=L,at=e(function(r,n){switch(r.$){case 0:var t=r.a;return h(Kr,d(tt,f=t.a,o=t.b,r.b,r.c),h(Kr,h(Qn,f,o),n));case 1:var e=r.a,u=r.b;return h(Kr,$(nt,f=e.a,o=e.b,u),h(Kr,h(Qn,f+u,o),n));case 2:var a=r.a,i=r.b;return $(an,Vn,h(Kr,h(Qn,f=a.a,o=a.b),n),i);default:var f,o,c=r.a,v=r.c;return h(Kr,b(rt,f=c.a,o=c.b,r.b,v,r.d,r.e),h(Kr,h(Qn,f+et(v),o+ut(v)),n))}}),it=e(function(r,n){return Dn(m([k("type",Pn("field")),k("name",Pn(r)),k("value",n)]))}),ft=M,ot=z,ct=function(r){var n,t,e=r.b,u=r.c,a=r.d,i=function(r){return ft(1e4*r)/100};return n=m(["rgba(",ot(i(r.a)),"%,",ot(i(e)),"%,",ot(i(u)),"%,",ot((t=a,ft(1e3*t)/1e3)),")"]),h(_n,"",n)},vt=function(r){return h(it,"fillStyle",Pn(ct(r)))},st=e(function(r,n){return h(Kr,h(Xn,"fill",m([Pn(function(r){return r?"evenodd":"nonzero"}(0))])),h(Kr,vt(r),n))}),bt=h(Xn,"stroke",l),lt=function(r){return h(it,"strokeStyle",Pn(ct(r)))},dt=e(function(r,n){return h(Kr,bt,h(Kr,lt(r),n))}),ht=u(function(r,n,t,e){return{$:0,a:r,b:n,c:t,d:e}}),$t=d(ht,0,0,0,1),gt=e(function(r,n){switch(r.$){case 0:return h(st,$t,n);case 1:return h(st,r.a,n);case 2:return h(dt,r.a,n);default:return h(dt,r.b,h(st,r.a,n))}}),mt=u(function(r,n,t,e){if(1===e.$)return h(Xn,"fillText",m([Pn(r),Gn(n),Gn(t)]));var u=e.a;return h(Xn,"fillText",m([Pn(r),Gn(n),Gn(t),Gn(u)]))}),pt=a(function(r,n,t,e,u){return h(Kr,d(mt,r.aE,n,t,r.an),h(Kr,vt(e),u))}),yt=u(function(r,n,t,e){if(1===e.$)return h(Xn,"strokeText",m([Pn(r),Gn(n),Gn(t)]));var u=e.a;return h(Xn,"strokeText",m([Pn(r),Gn(n),Gn(t),Gn(u)]))}),kt=a(function(r,n,t,e,u){return h(Kr,d(yt,r.aE,n,t,r.an),h(Kr,lt(e),u))}),wt=t(function(r,n,t){var e=n.a1,u=e.a,a=e.b;switch(r.$){case 0:return s(pt,n,u,a,$t,t);case 1:return s(pt,n,u,a,r.a,t);case 2:return s(kt,n,u,a,r.a,t);default:return s(kt,n,u,a,r.b,s(pt,n,u,a,r.a,t))}}),At=t(function(r,n,t){return $(wt,r,n,t)}),_t=f(function(r,n,t,e,u,a,i,f,o){return h(Xn,"drawImage",m([o,Gn(r),Gn(n),Gn(t),Gn(e),Gn(u),Gn(a),Gn(i),Gn(f)]))}),jt=u(function(t,e,u,r){return h(Kr,function(){if(u.$){var r=u.a;return o(_t,r.bN,r.bO,r.bM,r.av,t,e,r.bM,r.av,(n=u.b).co)}var n;return o(_t,0,0,(n=u.a).bM,n.av,t,e,n.bM,n.av,n.co)}(),r)}),Tt=t(function(r,n,t){return d(jt,r.a,r.b,n,t)}),Et=h(Xn,"beginPath",l),Nt=t(function(r,n,t){switch(r.$){case 0:return $(At,n,r.a,t);case 1:var e=r.a;return h(gt,n,$(an,at,h(Kr,Et,t),e));default:return $(Tt,r.a,r.b,t)}}),Lt=h(Xn,"restore",l),xt=h(Xn,"save",l),Ct=e(function(r,n){return h(Kr,Lt,$(Nt,r.Y,r.X,A(r.J,h(Kr,xt,n))))}),Mt=l,qt=function(r){switch(r.$){case 0:return 0;case 1:return 1;case 2:return 2;default:return 3}},Ot=e(function(r,n){return h($r,function(r){return"innerHTML"==r||"formAction"==r?"data-"+r:r}(r),function(r){return/^\s*(javascript:|data:text\/html)/i.test(r)?"":r}(n))}),zt=hr("canvas"),Jt=function(r){return hr(function(r){return"script"==r?"p":r}(r))},Rt=function(r){return h(gr,"height",An(r))},St=function(r){return h(gr,"width",An(r))},Yt=t(function(r,n,t){var e,u=r.a,a=r.b;return $(Jt,"elm-canvas",m([(e=function(r){return $(an,Ct,Mt,r)}(t),h(Ot,"cmds",h(In,Yn,e))),Rt(a),St(u)]),m([h(zt,h(Kr,Rt(a),h(Kr,St(u),n)),l)]))}),Ft=u(function(r,n,t,e){var u=function(r,n,t){return{a:r,b:n,c:t}}(r,n,t),a=u.a,i=u.b,f=u.c,o=.5<f?f+i-f*i:f*(i+1),c=2*f-o,v=function(r){var n=r<0?r+1:1<r?r-1:r;return 6*n<1?c+(o-c)*n*6:2*n<1?o:3*n<2?c+(o-c)*(2/3-n)*6:c},s=v(a-1/3),b=v(a),l=v(a+1/3);return d(ht,l,b,s,e)}),Bt=$(t(function(r,n,t){return d(Ft,r,n,t,1)}),3.141592653589793*39/180,.19,.86),It=function(r){return{$:0,a:r}},Dt=e(function(r,n){return h(Xn,"scale",m([Gn(r),Gn(n)]))}),Pt=i(function(r,n,t,e,u,a){return h(Xn,"transform",m([Gn(r),Gn(n),Gn(t),Gn(e),Gn(u),Gn(a)]))}),Xt=e(function(r,n){return h(Xn,"translate",m([Gn(r),Gn(n)]))}),Gt=u(function(r,n,t,e){if(e.b){var u=e.a,a=e.b;if(a.b){var i=a.a,f=a.b;if(f.b){var o=f.a,c=f.b;if(c.b){var v=c.b;return h(r,u,h(r,i,h(r,o,h(r,c.a,500<t?$(an,r,n,fn(v)):d(Gt,r,n,t+1,v)))))}return h(r,u,h(r,i,h(r,o,n)))}return h(r,u,h(r,i,n))}return h(r,u,n)}return n}),Ht=t(function(r,n,t){return d(Gt,r,n,0,t)}),Wt=e(function(t,r){return $(Ht,e(function(r,n){return h(Kr,t(r),n)}),l,r)}),Kt=function(r){return{$:1,a:h(Wt,function(r){switch(r.$){case 0:return function(r){return h(Xn,"rotate",m([Gn(r)]))}(r.a);case 1:return h(Dt,r.a,r.b);case 2:return h(Xt,r.a,r.b);default:return b(Pt,r.a.cq,r.a.cr,r.a.cs,r.a.ct,r.a.b6,r.a.b7)}},r)}},Qt=e(function(r,n){return{$:2,a:r,b:n}}),Ut=function(r){var n=r.a,t=277803737*(n^n>>>4+(n>>>28));return(t>>>22^t)>>>0},Vt=h(e(function(a,i){return function(r){var n,t=En(r),e=(n=i-a)<0?-n:n,u=Ut(t);return k((134217728*(1*(67108863&Ut(r)))+1*(134217727&u))/9007199254740992*e+a,En(t))}}),0,1),Zt=s(a(function(c,r,n,t,e){var v=r,s=n,b=t,l=e;return function(r){var n=v(r),t=n.a,e=s(n.b),u=e.a,a=b(e.b),i=a.a,f=l(a.b),o=f.b;return k(d(c,t,u,i,f.a),o)}}),u(function(r,n,t,e){return k(k(r,n),k(t,e))}),Vt,Vt,Vt,Vt),re=e(function(r,n){return r(n)}),ne=e(function(r,n){var t=r.b,e=function(r){return r<.5?-1:1},u=h(re,Zt,n),a=u.a,i=a.a,f=i.b,o=a.b,c=o.a,v=o.b,s=u.b;return k(k(t/20*3.141592653589793/180*e(i.a)*f*45,t/20*e(c)*v*15),s)}),te=e(function(r,n){var t,e=n.a,u=n.b,a=k(r.a,r.b),i=a.a,f=a.b,o=k(i*((500-500/6*2)/12)+500/6,f*((500-500/6*2)/12)+500/6),c=o.a,v=o.b,s=h(ne,k(i,f),u),b=s.a,l=b.a,d=s.b;return k(h(Kr,h(Bn,m([Kt(m([h(Qt,c+b.b,v),It(l)])),(t=$t,Mn(Rn(t)))]),m([$(On,k(0,0),(500-500/6*2)/12,(500-500/6*2)/12)])),e),d)}),ee=t(function(r,i,n){var f=r.cL,o=r.b_;return $(t(function(r,n,t){for(;;){if(-1<p(n,f))return t;if(p(r,o)>-1){r=e=0,n=u=n+1,t=a=t}else{var e=r+1,u=n,a=h(i,k(r,n),t);r=e,n=u,t=a}}}),0,0,n)}),ue=e(function(r,n){return $(ee,{b_:12,cL:20},te,k(n,r)).a}),ae=G,ie=ae(0),fe=W,oe=e(function(n,r){return h(fe,function(r){return ae(n(r))},r)}),ce=t(function(t,r,e){return h(fe,function(n){return h(fe,function(r){return ae(h(t,n,r))},e)},r)}),ve=ir,se=e(function(r,n){var t=n;return U(h(fe,ve(r),t))});ur.Task={b:ie,c:t(function(r,n){return h(oe,function(){return 0},(t=h(Wt,se(r),n),$(Ht,ce(Kr),ae(l),t)));var t}),d:t(function(){return ae(0)}),e:e(function(r,n){return h(oe,r,n)}),f:Wr};fr("Task");var be,le={$:4},de=Pr({cm:function(r){return k(k((n=Qr(1e6*r),t=En(h(Tn,0,1013904223)),En(h(Tn,t.a+n>>>0,t.b))),0),jn);var n,t},cR:function(){return Nn},cY:xn,c_:function(r){var n,t=h(ue,r.a,l),e=h(Bn,m([(n=Bt,Mn(Cn(n)))]),m([$(On,k(0,0),500,722.2222222222223)]));return $(Yt,k(500,Qr(722.2222222222223)),l,h(Kr,e,t))}});be={Examples:{CubicDisarray:{init:de(le)(0)}}},r.Elm?function r(n,t){for(var e in t)e in n?"init"==e?T(6):r(n[e],t[e]):n[e]=t[e]}(r.Elm,be):r.Elm=be}(this);