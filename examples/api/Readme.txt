CMS Hypermedia API and Adaptive Web Design
============================================


A content management system is not a simple domain.
This example shows how to build a basic Hypermedia API for a CMS using HTML5 and progressive enhacement.
The idea is based on an existing [Eiffel CMS] (https://github.com/EiffelWebFramework/cms), the goal is learn the domain and create a new modular CMS.

Persistence
============
The current solution uses MySQL and only handle users and nodes concept.


Authentication/Authorization
============================
Basic Auth.


API features
============

There is no session.

The root uri:
	shows Navigation and the possiblity to add a New Node (only for loggedin users).
	shows a predefined number of nodes the `n' most recent nodes.

Guest users will be able to list all the nodes and view a particular node.
Logged in users.
Logged users are able to 
Add a new node
Edit an existing node
Edit a node title
Edit a node summary
Edit a node content
Delete a node


Server Modes
============

api: HTML5 API
html: api with progresive enhacements css and js, server side rendering.
web: api with progresive enhacements css and js and Ajax calls.

References

1:  http://codeartisan.blogspot.se/2012/07/using-html-as-media-type-for-your-api.html
2:  https://github.com/gustafnk/combining-html-hypermedia-apis-and-adaptive-web-design