!function(n){"use strict";function r(n,r,t){return t.a=n,t.f=r,t}function e(t){return r(2,t,function(r){return function(n){return t(r,n)}})}function t(e){return r(3,e,function(t){return function(r){return function(n){return e(t,r,n)}}})}function u(u){return r(4,u,function(e){return function(t){return function(r){return function(n){return u(e,t,r,n)}}}})}function a(a){return r(5,a,function(u){return function(e){return function(t){return function(r){return function(n){return a(u,e,t,r,n)}}}}})}function h(n,r,t){return 2===n.a?n.f(r,t):n(r)(t)}function g(n,r,t,e){return 3===n.a?n.f(r,t,e):n(r)(t)(e)}function s(n,r,t,e,u){return 4===n.a?n.f(r,t,e,u):n(r)(t)(e)(u)}function $(n,r,t,e,u,a){return 5===n.a?n.f(r,t,e,u,a):n(r)(t)(e)(u)(a)}var m={$:0};function b(n,r){return{$:1,a:n,b:r}}var i=e(b);function l(n){for(var r=m,t=n.length;t--;)r=b(n[t],r);return r}function c(n,r,t){if("object"!=typeof n)return n===r?0:n<r?-1:1;if(!n.$)return(t=c(n.a,r.a))?t:(t=c(n.b,r.b))?t:c(n.c,r.c);for(;n.b&&r.b&&!(t=c(n.a,r.a));n=n.b,r=r.b);return t||(n.b?1:r.b?-1:0)}var f=0;function p(n,r){return{a:n,b:r}}function o(n,r,t){return{a:n,b:r,c:t}}var v=t(function(n,r,t){for(var e=Array(n),u=0;u<n;u++)e[u]=t(r+u);return e}),d=e(function(n,r){for(var t=Array(n),e=0;e<n&&r.b;e++)t[e]=r.a,r=r.b;return t.length=e,p(t,r)});function y(n){throw Error("https://github.com/elm/core/blob/1.0.0/hints/"+n+".md")}var A=e(Math.pow),k=Math.sin;var w=Math.ceil,j=Math.floor,_=Math.round,E=Math.log;function N(n){return n+""}var L=e(function(n,r){return T(n,O(r))});function T(n,r){switch(n.$){case 3:return"boolean"==typeof r?dr(r):q("a BOOL",r);case 2:return"number"!=typeof r?q("an INT",r):-2147483647<r&&r<2147483647&&(0|r)===r?dr(r):!isFinite(r)||r%1?q("an INT",r):dr(r);case 4:return"number"==typeof r?dr(r):q("a FLOAT",r);case 6:return"string"==typeof r?dr(r):r instanceof String?dr(r+""):q("a STRING",r);case 9:return null===r?dr(n.c):q("null",r);case 5:return dr(M(r));case 7:return Array.isArray(r)?F(n.b,r,l):q("a LIST",r);case 8:return Array.isArray(r)?F(n.b,r,B):q("an ARRAY",r);case 10:var t=n.d;if("object"!=typeof r||null===r||!(t in r))return q("an OBJECT with a field named `"+t+"`",r);var e=T(n.b,r[t]);return Yn(e)?e:lr(h(gr,t,e.a));case 11:var u=n.e;if(!Array.isArray(r))return q("an ARRAY",r);if(r.length<=u)return q("a LONGER array. Need index "+u+" but only see "+r.length+" entries",r);e=T(n.b,r[u]);return Yn(e)?e:lr(h($r,u,e.a));case 12:if("object"!=typeof r||null===r||Array.isArray(r))return q("an OBJECT",r);var a=m;for(var i in r)if(r.hasOwnProperty(i)){e=T(n.b,r[i]);if(!Yn(e))return lr(h(gr,i,e.a));a=b(p(i,e.a),a)}return dr(rr(a));case 13:for(var f=n.f,o=n.g,c=0;c<o.length;c++){e=T(o[c],r);if(!Yn(e))return e;f=f(e.a)}return dr(f);case 14:e=T(n.b,r);return Yn(e)?T(n.h(e.a),r):e;case 15:for(var v=m,s=n.g;s.b;s=s.b){e=T(s.a,r);if(Yn(e))return e;v=b(e.a,v)}return lr(mr(rr(v)));case 1:return lr(h(hr,n.a,M(r)));case 0:return dr(n.a)}}function F(n,r,t){for(var e=r.length,u=Array(e),a=0;a<e;a++){var i=T(n,r[a]);if(!Yn(i))return lr(h($r,a,i.a));u[a]=i.a}return dr(t(u))}function B(r){return h(vr,r.length,function(n){return r[n]})}function q(n,r){return lr(h(hr,"Expecting "+n,M(r)))}function x(n,r){if(n===r)return!0;if(n.$!==r.$)return!1;switch(n.$){case 0:case 1:return n.a===r.a;case 3:case 2:case 4:case 6:case 5:return!0;case 9:return n.c===r.c;case 7:case 8:case 12:return x(n.b,r.b);case 10:return n.d===r.d&&x(n.b,r.b);case 11:return n.e===r.e&&x(n.b,r.b);case 13:return n.f===r.f&&C(n.g,r.g);case 14:return n.h===r.h&&x(n.b,r.b);case 15:return C(n.g,r.g)}}function C(n,r){var t=n.length;if(t!==r.length)return!1;for(var e=0;e<t;e++)if(!x(n[e],r[e]))return!1;return!0}function M(n){return n}function O(n){return n}var R=t(function(n,r,t){return t[n]=O(r),t});M(null);function S(n){return{$:0,a:n}}function z(n){return{$:2,b:n,c:null}}var P=e(function(n,r){return{$:3,b:n,d:r}});var D=0;function G(n){var r={$:0,e:D++,f:n,g:null,h:[]};return W(r),r}function J(r){return z(function(n){n(S(G(r)))})}function I(n,r){n.h.push(r),W(n)}var Y=e(function(r,t){return z(function(n){I(r,t),n(S(f))})});var Q=!1,H=[];function W(n){if(H.push(n),!Q){for(Q=!0;n=H.shift();)K(n);Q=!1}}function K(r){for(;r.f;){var n=r.f.$;if(0===n||1===n){for(;r.g&&r.g.$!==n;)r.g=r.g.i;if(!r.g)return;r.f=r.g.b(r.f.a),r.g=r.g.i}else{if(2===n)return void(r.f.c=r.f.b(function(n){r.f=n,W(r)}));if(5===n){if(0===r.h.length)return;r.f=r.f.b(r.h.shift())}else r.g={$:3===n?0:1,b:r.f.b,i:r.g},r.f=r.f.d}}}function U(n,r,t,e,u,a){var i=h(L,n,M(r?r.flags:void 0));Yn(i)||y(2);var f={},o=(i=t(i.a)).a,c=a(s,o),v=function(n,r){var t;for(var e in V){var u=V[e];u.a&&((t=t||{})[e]=u.a(e,r)),n[e]=Z(u,r)}return t}(f,s);function s(n,r){c(o=(i=h(e,n,o)).a,r),un(f,i.b,u(o))}return un(f,i.b,u(o)),v?{ports:v}:{}}var V={};function X(n,r,t,e,u){return{b:n,c:r,d:t,e:e,f:u}}function Z(n,r){var e={g:r,h:void 0},u=n.c,a=n.d,i=n.e,f=n.f;function o(t){return h(P,o,{$:5,b:function(n){var r=n.a;return 0===n.$?g(a,e,r,t):i&&f?s(u,e,r.i,r.j,t):g(u,e,i?r.i:r.j,t)}})}return e.h=G(h(P,o,n.b))}var nn=e(function(r,t){return z(function(n){r.g(t),n(S(f))})}),rn=e(function(n,r){return h(Y,n.h,{$:0,a:r})});function tn(r){return function(n){return{$:1,k:r,l:n}}}function en(n){return{$:2,m:n}}function un(n,r,t){var e={};for(var u in an(!0,r,e,null),an(!1,t,e,null),n)I(n[u],{$:"fx",a:e[u]||{i:m,j:m}})}function an(n,r,t,e){switch(r.$){case 1:var u=r.k,a=function(n,r,t,e){function u(n){for(var r=t;r;r=r.q)n=r.p(n);return n}return h(n?V[r].e:V[r].f,u,e)}(n,u,e,r.l);return void(t[u]=function(n,r,t){return t=t||{i:m,j:m},n?t.i=b(r,t.i):t.j=b(r,t.j),t}(n,a,t[u]));case 2:for(var i=r.m;i.b;i=i.b)an(n,i.a,t,e);return;case 3:return void an(n,r.o,t,{p:r.n,q:e})}}var fn;var on="undefined"!=typeof document?document:{};function cn(n,r){n.appendChild(r)}function vn(n){return{$:0,a:n}}var sn=e(function(a,i){return e(function(n,r){for(var t=[],e=0;r.b;r=r.b){var u=r.a;e+=u.b||0,t.push(u)}return e+=t.length,{$:1,c:i,d:gn(n),e:t,f:a,b:e}})})(void 0);e(function(a,i){return e(function(n,r){for(var t=[],e=0;r.b;r=r.b){var u=r.a;e+=u.b.b||0,t.push(u)}return e+=t.length,{$:2,c:i,d:gn(n),e:t,f:a,b:e}})})(void 0);var bn=e(function(n,r){return{$:"a0",n:n,o:r}}),ln=e(function(n,r){return{$:"a2",n:n,o:r}}),dn=e(function(n,r){return{$:"a3",n:n,o:r}});var hn;function gn(n){for(var r={};n.b;n=n.b){var t=n.a,e=t.$,u=t.n,a=t.o;if("a2"!==e){var i=r[e]||(r[e]={});"a3"===e&&"class"===u?$n(i,u,a):i[u]=a}else"className"===u?$n(r,u,O(a)):r[u]=O(a)}return r}function $n(n,r,t){var e=n[r];n[r]=e?e+" "+t:t}function mn(n,r){var t=n.$;if(5===t)return mn(n.k||(n.k=n.m()),r);if(0===t)return on.createTextNode(n.a);if(4===t){for(var e=n.k,u=n.j;4===e.$;)"object"!=typeof u?u=[u,e.j]:u.push(e.j),e=e.k;var a={j:u,p:r};return(i=mn(e,a)).elm_event_node_ref=a,i}if(3===t)return pn(i=n.h(n.g),r,n.d),i;var i=n.f?on.createElementNS(n.f,n.c):on.createElement(n.c);fn&&"a"==n.c&&i.addEventListener("click",fn(i)),pn(i,r,n.d);for(var f=n.e,o=0;o<f.length;o++)cn(i,mn(1===t?f[o]:f[o].b,r));return i}function pn(n,r,t){for(var e in t){var u=t[e];"a1"===e?yn(n,u):"a0"===e?wn(n,r,u):"a3"===e?An(n,u):"a4"===e?kn(n,u):("value"!==e||"checked"!==e||n[e]!==u)&&(n[e]=u)}}function yn(n,r){var t=n.style;for(var e in r)t[e]=r[e]}function An(n,r){for(var t in r){var e=r[t];e?n.setAttribute(t,e):n.removeAttribute(t)}}function kn(n,r){for(var t in r){var e=r[t],u=e.f,a=e.o;a?n.setAttributeNS(u,t,a):n.removeAttributeNS(u,t)}}function wn(n,r,t){var e=n.elmFs||(n.elmFs={});for(var u in t){var a=t[u],i=e[u];if(a){if(i){if(i.q.$===a.$){i.q=a;continue}n.removeEventListener(u,i)}i=jn(r,a),n.addEventListener(u,i,hn&&{passive:Sr(a)<2}),e[u]=i}else n.removeEventListener(u,i),e[u]=void 0}}try{window.addEventListener("t",null,Object.defineProperty({},"passive",{get:function(){hn=!0}}))}catch(n){}function jn(v,n){function s(n){var r=s.q,t=T(r.a,n);if(Yn(t)){for(var e,u=Sr(r),a=t.a,i=u?u<3?a.a:a.L:a,f=1==u?a.b:3==u&&a.a1,o=(f&&n.stopPropagation(),(2==u?a.b:3==u&&a.aY)&&n.preventDefault(),v);e=o.j;){if("function"==typeof e)i=e(i);else for(var c=e.length;c--;)i=e[c](i);o=o.p}o(i,f)}}return s.q=n,s}function _n(n,r){return n.$==r.$&&x(n.a,r.a)}function En(n,r){var t=[];return Ln(n,r,t,0),t}function Nn(n,r,t,e){var u={$:r,r:t,s:e,t:void 0,u:void 0};return n.push(u),u}function Ln(n,r,t,e){if(n!==r){var u=n.$,a=r.$;if(u!==a){if(1!==u||2!==a)return void Nn(t,0,e,r);r=function(n){for(var r=n.e,t=r.length,e=Array(t),u=0;u<t;u++)e[u]=r[u].b;return{$:1,c:n.c,d:n.d,e:e,f:n.f,b:n.b}}(r),a=1}switch(a){case 5:for(var i=n.l,f=r.l,o=i.length,c=o===f.length;c&&o--;)c=i[o]===f[o];if(c)return void(r.k=n.k);r.k=r.m();var v=[];return Ln(n.k,r.k,v,0),void(0<v.length&&Nn(t,1,e,v));case 4:for(var s=n.j,b=r.j,l=!1,d=n.k;4===d.$;)l=!0,"object"!=typeof s?s=[s,d.j]:s.push(d.j),d=d.k;for(var h=r.k;4===h.$;)l=!0,"object"!=typeof b?b=[b,h.j]:b.push(h.j),h=h.k;return l&&s.length!==b.length?void Nn(t,0,e,r):((l?function(n,r){for(var t=0;t<n.length;t++)if(n[t]!==r[t])return!1;return!0}(s,b):s===b)||Nn(t,2,e,b),void Ln(d,h,t,e+1));case 0:return void(n.a!==r.a&&Nn(t,3,e,r.a));case 1:return void Tn(n,r,t,e,Bn);case 2:return void Tn(n,r,t,e,qn);case 3:if(n.h!==r.h)return void Nn(t,0,e,r);var g=Fn(n.d,r.d);g&&Nn(t,4,e,g);var $=r.i(n.g,r.g);return void($&&Nn(t,5,e,$))}}}function Tn(n,r,t,e,u){if(n.c===r.c&&n.f===r.f){var a=Fn(n.d,r.d);a&&Nn(t,4,e,a),u(n,r,t,e)}else Nn(t,0,e,r)}function Fn(n,r,t){var e;for(var u in n)if("a1"!==u&&"a0"!==u&&"a3"!==u&&"a4"!==u)if(u in r){var a=n[u],i=r[u];a===i&&"value"!==u&&"checked"!==u||"a0"===t&&_n(a,i)||((e=e||{})[u]=i)}else(e=e||{})[u]=t?"a1"===t?"":"a0"===t||"a3"===t?void 0:{f:n[u].f,o:void 0}:"string"==typeof n[u]?"":null;else{var f=Fn(n[u],r[u]||{},u);f&&((e=e||{})[u]=f)}for(var o in r)o in n||((e=e||{})[o]=r[o]);return e}function Bn(n,r,t,e){var u=n.e,a=r.e,i=u.length,f=a.length;f<i?Nn(t,6,e,{v:f,i:i-f}):i<f&&Nn(t,7,e,{v:i,e:a});for(var o=i<f?i:f,c=0;c<o;c++){var v=u[c];Ln(v,a[c],t,++e),e+=v.b||0}}function qn(n,r,t,e){for(var u=[],a={},i=[],f=n.e,o=r.e,c=f.length,v=o.length,s=0,b=0,l=e;s<c&&b<v;){var d=(E=f[s]).a,h=(N=o[b]).a,g=E.b,$=N.b;if(d!==h){var m=f[s+1],p=o[b+1];if(m)var y=m.a,A=m.b,k=h===y;if(p)var w=p.a,j=p.b,_=d===w;if(_&&k)Ln(g,j,u,++l),Cn(a,u,d,$,b,i),l+=g.b||0,Mn(a,u,d,A,++l),l+=A.b||0,s+=2,b+=2;else if(_)l++,Cn(a,u,h,$,b,i),Ln(g,j,u,l),l+=g.b||0,s+=1,b+=2;else if(k)Mn(a,u,d,g,++l),l+=g.b||0,Ln(A,$,u,++l),l+=A.b||0,s+=2,b+=1;else{if(!m||y!==w)break;Mn(a,u,d,g,++l),Cn(a,u,h,$,b,i),l+=g.b||0,Ln(A,j,u,++l),l+=A.b||0,s+=2,b+=2}}else Ln(g,$,u,++l),l+=g.b||0,s++,b++}for(;s<c;){var E;Mn(a,u,(E=f[s]).a,g=E.b,++l),l+=g.b||0,s++}for(;b<v;){var N,L=L||[];Cn(a,u,(N=o[b]).a,N.b,void 0,L),b++}(0<u.length||0<i.length||L)&&Nn(t,8,e,{w:u,x:i,y:L})}var xn="_elmW6BL";function Cn(n,r,t,e,u,a){var i=n[t];if(!i)return a.push({r:u,A:i={c:0,z:e,r:u,s:void 0}}),void(n[t]=i);if(1===i.c){a.push({r:u,A:i}),i.c=2;var f=[];return Ln(i.z,e,f,i.r),i.r=u,void(i.s.s={w:f,A:i})}Cn(n,r,t+xn,e,u,a)}function Mn(n,r,t,e,u){var a=n[t];if(a){if(0===a.c){a.c=2;var i=[];return Ln(e,a.z,i,u),void Nn(r,9,u,{w:i,A:a})}Mn(n,r,t+xn,e,u)}else{var f=Nn(r,9,u,void 0);n[t]={c:1,z:e,r:u,s:f}}}function On(n,r,t,e){!function n(r,t,e,u,a,i,f){var o=e[u];var c=o.r;for(;c===a;){var v=o.$;if(1===v)On(r,t.k,o.s,f);else if(8===v){o.t=r,o.u=f;var s=o.s.w;0<s.length&&n(r,t,s,0,a,i,f)}else if(9===v){o.t=r,o.u=f;var b=o.s;if(b){b.A.s=r;var s=b.w;0<s.length&&n(r,t,s,0,a,i,f)}}else o.t=r,o.u=f;if(!(o=e[++u])||(c=o.r)>i)return u}var l=t.$;if(4===l){for(var d=t.k;4===d.$;)d=d.k;return n(r,d,e,u,a+1,i,r.elm_event_node_ref)}var h=t.e;var g=r.childNodes;for(var $=0;$<h.length;$++){var m=1===l?h[$]:h[$].b,p=++a+(m.b||0);if(a<=c&&c<=p&&(u=n(g[$],m,e,u,a,p,f),!(o=e[u])||(c=o.r)>i))return u;a=p}return u}(n,r,t,0,0,r.b,e)}function Rn(n,r,t,e){return 0===t.length?n:(On(n,r,t,e),Sn(n,t))}function Sn(n,r){for(var t=0;t<r.length;t++){var e=r[t],u=e.t,a=zn(u,e);u===n&&(n=a)}return n}function zn(n,r){switch(r.$){case 0:return function(n,r,t){var e=n.parentNode,u=mn(r,t);u.elm_event_node_ref||(u.elm_event_node_ref=n.elm_event_node_ref);e&&u!==n&&e.replaceChild(u,n);return u}(n,r.s,r.u);case 4:return pn(n,r.u,r.s),n;case 3:return n.replaceData(0,n.length,r.s),n;case 1:return Sn(n,r.s);case 2:return n.elm_event_node_ref?n.elm_event_node_ref.j=r.s:n.elm_event_node_ref={j:r.s,p:r.u},n;case 6:for(var t=r.s,e=0;e<t.i;e++)n.removeChild(n.childNodes[t.v]);return n;case 7:for(var u=(t=r.s).e,a=n.childNodes[e=t.v];e<u.length;e++)n.insertBefore(mn(u[e],r.u),a);return n;case 9:if(!(t=r.s))return n.parentNode.removeChild(n),n;var i=t.A;return void 0!==i.r&&n.parentNode.removeChild(n),i.s=Sn(n,t.w),n;case 8:return function(n,r){var t=r.s,e=function(n,r){if(!n)return;for(var t=on.createDocumentFragment(),e=0;e<n.length;e++){var u=n[e],a=u.A;cn(t,2===a.c?a.s:mn(a.z,r.u))}return t}(t.y,r);n=Sn(n,t.w);for(var u=t.x,a=0;a<u.length;a++){var i=u[a],f=i.A,o=2===f.c?f.s:mn(f.z,r.u);n.insertBefore(o,n.childNodes[i.r])}e&&cn(n,e);return n}(n,r);case 5:return r.s(n);default:y(10)}}function Pn(n){if(3===n.nodeType)return vn(n.textContent);if(1!==n.nodeType)return vn("");for(var r=m,t=n.attributes,e=t.length;e--;){var u=t[e];r=b(h(dn,u.name,u.value),r)}var a=n.tagName.toLowerCase(),i=m,f=n.childNodes;for(e=f.length;e--;)i=b(Pn(f[e]),i);return g(sn,a,r,i)}var Dn=u(function(r,n,t,f){return U(n,f,r.b8,r.cE,r.cy,function(e,n){var u=r.cG,a=f.node,i=Pn(a);return Jn(n,function(n){var r=u(n),t=En(i,r);a=Rn(a,i,t,e),i=r})})}),Gn="undefined"!=typeof requestAnimationFrame?requestAnimationFrame:function(n){setTimeout(n,1e3/60)};function Jn(t,e){e(t);var u=0;function a(){u=1===u?0:(Gn(a),e(t),1)}return function(n,r){t=n,r?(e(t),2===u&&(u=1)):(0===u&&Gn(a),u=2)}}var In={addEventListener:function(){},removeEventListener:function(){}};"undefined"!=typeof document&&document,"undefined"!=typeof window&&window;var Yn=function(n){return!n.$},Qn=i,Hn=u(function(n,r,t,e){return{$:0,a:n,b:r,c:t,d:e}}),Wn=w,Kn=e(function(n,r){return E(r)/E(n)}),Un=Wn(h(Kn,2,32)),Vn=[],Xn=s(Hn,0,Un,Vn,Vn),Zn=d,nr=t(function(n,r,t){for(;;){if(!t.b)return r;var e=t.b,u=n,a=h(n,t.a,r);n=u,r=a,t=e}}),rr=function(n){return g(nr,Qn,m,n)},tr=e(function(n,r){for(;;){var t=h(Zn,32,n),e=t.b,u=h(Qn,{$:0,a:t.a},r);if(!e.b)return rr(u);n=e,r=u}}),er=e(function(n,r){for(;;){var t=Wn(r/32);if(1===t)return h(Zn,32,n).a;n=h(tr,n,m),r=t}}),ur=j,ar=e(function(n,r){return 0<c(n,r)?n:r}),ir=function(n){return n.length},fr=e(function(n,r){if(r.k){var t=32*r.k,e=ur(h(Kn,32,t-1)),u=n?rr(r.o):r.o,a=h(er,u,r.k);return s(Hn,ir(r.n)+t,h(ar,5,e*Un),a,r.n)}return s(Hn,ir(r.n),Un,Vn,r.n)}),or=v,cr=a(function(n,r,t,e,u){for(;;){if(r<0)return h(fr,!1,{o:e,k:t/32|0,n:u});var a={$:1,a:g(or,32,r,n)};n=n,r=r-32,t=t,e=h(Qn,a,e),u=u}}),vr=e(function(n,r){if(0<n){var t=n%32;return $(cr,r,n-t-32,n,m,g(or,t,n-t,r))}return Xn}),sr=function(n){return{$:0,a:n}},br={$:1},lr=function(n){return{$:1,a:n}},dr=function(n){return{$:0,a:n}},hr=e(function(n,r){return{$:3,a:n,b:r}}),gr=e(function(n,r){return{$:0,a:n,b:r}}),$r=e(function(n,r){return{$:1,a:n,b:r}}),mr=function(n){return{$:2,a:n}},pr=N,yr=en(m),Ar=function(n){return{$:0,a:n}},kr=function(n){return{$:0,a:n}},wr=t(function(n,r,t){return{aP:t,by:r,bB:n}}),jr=S,_r=jr(g(wr,m,br,0)),Er=function(n){return n},Nr=jr(0),Lr=u(function(n,r,t,e){if(e.b){var u=e.a,a=e.b;if(a.b){var i=a.a,f=a.b;if(f.b){var o=f.a,c=f.b;if(c.b){var v=c.b;return h(n,u,h(n,i,h(n,o,h(n,c.a,500<t?g(nr,n,r,rr(v)):s(Lr,n,r,t+1,v)))))}return h(n,u,h(n,i,h(n,o,r)))}return h(n,u,h(n,i,r))}return h(n,u,r)}return r}),Tr=t(function(n,r,t){return s(Lr,n,r,0,t)}),Fr=e(function(t,n){return g(Tr,e(function(n,r){return h(Qn,t(n),r)}),m,n)}),Br=P,qr=e(function(r,n){return h(Br,function(n){return jr(r(n))},n)}),xr=t(function(t,n,e){return h(Br,function(r){return h(Br,function(n){return jr(h(t,r,n))},e)},n)}),Cr=function(n){return g(Tr,xr(Qn),jr(m),n)},Mr=nn,Or=e(function(n,r){var t=r;return J(h(Br,Mr(n),t))});V.Task=X(Nr,t(function(n,r){return h(qr,function(){return 0},Cr(h(Fr,Or(n),r)))}),t(function(){return jr(0)}),e(function(n,r){return h(qr,n,r)}));tn("Task");var Rr=function(n){return{$:0,a:n}},Sr=function(n){switch(n.$){case 0:return 0;case 1:return 1;case 2:return 2;default:return 3}},zr=z(function(n){n(S(Date.now()))}),Pr=z(function(n){var r=requestAnimationFrame(function(){n(S(Date.now()))});return function(){cancelAnimationFrame(r)}}),Dr=rn,Gr=function(t){return z(function(n){var r=t.f;2===r.$&&r.c&&r.c(),t.f=null,n(S(f))})},Jr=J,Ir=t(function(n,t,r){var e=r.by,u=r.aP,a=p(e,t);if(1!==a.a.$)return a.b.b?jr(g(wr,t,e,u)):h(Br,function(){return _r},Gr(a.a.a));if(a.b.b){return h(Br,function(r){return h(Br,function(n){return jr(g(wr,t,sr(r),n))},zr)},Jr(h(Br,Dr(n),Pr)))}return _r}),Yr=Er,Qr=t(function(r,t,n){var e=n.bB,u=n.aP,a=function(n){return h(Mr,r,n.$?(0,n.a)(t-u):(0,n.a)(Yr(t)))};return h(Br,function(n){return h(Br,function(){return jr(g(wr,e,sr(n),t))},Cr(h(Fr,a,e)))},Jr(h(Br,Dr(r),Pr)))}),Hr=t(function(n,r,t){return n(r(t))});V["Browser.AnimationManager"]=X(_r,Ir,Qr,0,e(function(n,r){return r.$?{$:1,a:h(Hr,n,r.a)}:kr(h(Hr,n,r.a))}));var Wr,Kr=tn("Browser.AnimationManager"),Ur=function(n){return Kr(kr(n))},Vr=en(m),Xr=e(function(n,r){var t=r.a;return p(n.$?p(!t,r.b):p(t,function(n){return n}(n.a)),yr)}),Zr=e(function(n,r){return h(ln,function(n){return"innerHTML"==n||"formAction"==n?"data-"+n:n}(n),function(n){return/^\s*(javascript:|data:text\/html)/i.test(n)?"":n}(r))}),nt=e(function(n,r){return M(g(nr,function(t){return e(function(n,r){return r.push(O(t(n))),r})}(n),[],r))}),rt=e(function(n,r){return r.b?g(Tr,Qn,r,n):n}),tt=sn("canvas"),et=function(n){return sn(function(n){return"script"==n?"p":n}(n))},ut=u(function(n,r,t,e){return g(et,"elm-canvas",l([(i=e,h(Zr,"cmds",h(nt,Er,i)))]),l([h(tt,(u=l([l([(a=r,h(dn,"height",pr(a))),function(n){return h(dn,"width",pr(n))}(n)]),t]),g(Tr,rt,m,u)),m)]));var u,a,i}),at=m,it=e(function(n,r){return h(Qn,r,n)}),ft=e(function(n,r){var t=ur(n);return t%r+n-t}),ot=function(n){return n<0?-n:n},ct=function(n){return 3.141592653589793*n/180},vt=t(function(n,r,t){var e=n/ct(60),u=(1-ot(2*t-1))*r,a=t-u/2,i=u*(1-ot(h(ft,e,2)-1)),f=e<0?o(0,0,0):e<1?o(u,i,0):e<2?o(i,u,0):e<3?o(0,u,i):e<4?o(0,i,u):e<5?o(i,0,u):e<6?o(u,0,i):o(0,0,0);return o(f.a+a,f.b+a,f.c+a)}),st=_,bt=N,lt=function(n){var r=function(n){if(n.$){u=n.d;var r=g(vt,n.a,n.b,n.c);return t=r.a,e=r.b,{bF:u,bJ:st(255*r.c),b2:st(255*e),cr:st(255*t)}}var t,e,u;return{bF:u=n.d,bJ:n.c,b2:e=n.b,cr:t=n.a}}(n),t=r.b2,e=r.bJ,u=r.bF;return"rgba("+pr(r.cr)+", "+pr(t)+", "+pr(e)+", "+bt(u)+")"},dt=function(n){return M(g(nr,e(function(n,r){return g(R,n.a,n.b,r)}),{},n))},ht=M,gt=e(function(n,r){return dt(l([p("type",ht("field")),p("name",ht(n)),p("value",r)]))}),$t=e(function(n,r){return h(it,r,h(gt,"fillStyle",ht(lt(n))))}),mt=u(function(n,r,t,e){return{$:0,a:n,b:r,c:t,d:e}}),pt=mt,yt={$:1},At=e(function(n,r){return dt(l([p("type",ht("function")),p("name",ht(n)),p("args",h(nt,Er,r))]))}),kt=M,wt=a(function(n,r,t,e,u){return h(it,u,h(At,"clearRect",l([kt(n),kt(r),kt(t),kt(e)])))}),jt=a(function(n,r,t,e,u){return h(it,u,h(At,"fillRect",l([kt(n),kt(r),kt(t),kt(e)])))}),_t=t(function(n,r,t){return s(mt,n,r,t,1)}),Et=e(function(n,r){return h(it,r,h(At,"rotate",l([kt(n)])))}),Nt=t(function(n,r,t){return h(it,t,h(At,"translate",l([kt(n),kt(r)])))}),Lt=A,Tt=k,Ft=t(function(n,r,t){var e=r.a,u=r.b,a=n/1e3,i=ct(90),f=p(e,u),o=f.a,c=f.b,v=p(o/23,c/23),s=i+3.141592653589793*h(Lt,Tt(a+(.4*v.a+.2*v.b)),3),b=p(c*(400/24)+50+400/24/2,o*(400/24)+50+400/24/2),l=b.a,d=b.b;return function(n){return h(it,n,h(At,"restore",m))}($(jt,l-400/24*.65/2,d-400/24*.1/2,400/24*.65,400/24*.1,g(Nt,-l,-d,h(Et,s,g(Nt,l,d,h($t,g(_t,0,0,0),function(n){return h(it,n,h(At,"save",m))}(t)))))))}),Bt=t(function(n,i,r){var f=n.ct,o=n.bQ;return g(t(function(n,r,t){for(;;){if(-1<c(r,f))return t;if(c(n,o)>-1){n=e=0,r=u=r+1,t=a=t}else{var e=n+1,u=r,a=h(i,p(n,r),t);n=e,r=u,t=a}}}),0,0,r)}),qt=e(function(n,r){return g(Bt,{bQ:24,ct:24},Ft(n),r)}),xt=bn,Ct=e(function(n,r){return h(xt,n,{$:0,a:r})}),Mt=Dn({b8:function(){return p(p(!0,0),yr)},cy:function(n){return n.a?Ur(Ar):Vr},cE:Xr,cG:function(n){var r,t,e=n.b;return s(ut,st(500),st(500),l([(t=yt,h(Ct,"click",Rr(t)))]),h(qt,e,h($t,s(pt,0,0,0,1),(r=at,$(jt,0,0,500,500,h($t,g(_t,255,255,255),$(wt,0,0,500,500,r)))))))}});Wr={Examples:{AnimatedGrid:{init:Mt(Rr(0))(0)}}},n.Elm?function n(r,t){for(var e in t)e in r?"init"==e?y(6):n(r[e],t[e]):r[e]=t[e]}(n.Elm,Wr):n.Elm=Wr}(this);