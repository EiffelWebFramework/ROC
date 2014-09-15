CMS Hyperemedia API and Adaptive Web Design
============================================


A content management system is not a simple domain.
This example shows how to build a basic Hypermedia API for a CMS using HTML5 and progressive enhacement.
The idea is based on an existing Eiffel CMS, the goal is learn the domain and create a new modular CMS.

Persistence
============
The current solution uses MySQL and only handle the nodes concept.


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
Logged in users (There is only one user: admin)
Logged users are able to 
Add a new node
Edit an existing node
Edit a node title
Edit a node summary
Edit a node content
Delete a node


References

1:  http://codeartisan.blogspot.se/2012/07/using-html-as-media-type-for-your-api.html
2:  https://github.com/gustafnk/combining-html-hypermedia-apis-and-adaptive-web-design