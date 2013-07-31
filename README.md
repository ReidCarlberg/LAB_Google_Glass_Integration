First ~~terrible~~ Mediocre Salesforce.com / Google Glass / Mirror API code.

Basic use case: a new lead comes in, trigger fires, a message gets posted to the timeline.

![](https://raw.github.com/ReidCarlberg/LAB_Google_Glass_Integration/master/img/radioactivecats.png)

Thoughts so far:

* Updated -- actually using those now ~~I'm not doing anything great on refresh_tokens~~.
* Added LAB_Error page which is essentially useless but reminds me to put more error handling in later.
* There are no tests.
* The basic use case is around lead insert, should maybe do it on lead update so that it happened when people get assigned a lead.
* Another interesting thing would be a periodic status update -- 3 unread leads, 4 new tasks, etc.
* My glasses aren't chiming when new leads come in.
