scheduler-commander
===================

 Experimental command line interface to a persistent rufus-scheduler process.

Schedulables can be scheduled, removed, paused, and resumed without starting the main process.

Requirements
============

ruby or jruby or anything that rufus-scheduler supports.

Usage
=====

Starting the server
-------------------
`ruby run_job_server.rb`

Connecting to the control port
------------------------------
`telnet localhost 2000`

Help
----

<code>
**help**
&gt; Valid commands: list, add, delete, pause, resume, help, jobs</code>

List schedulable jobs
---------------------

<code>
**jobs**
&gt; +--------+---------------------+
| Work   | Displays some text. |
| Looper | Displays some text. |
+--------+---------------------+</code>

Add instance of a job
---------------------

<code>
**add work\_job every 5s Work**
&gt; Added job work\_job
</code>

<code>
**add loop_job in 5s Looper**
&gt; Added job loop\_job
</code>

List scheduled jobs
-------------------
<code>
  **list**
  &gt; +----------+---------+----------+---------------------------+---------------------------+
  | Name     | Status  | Interval | Last Run                  | Next Run                  |
  +----------+---------+----------+---------------------------+---------------------------+
  | work_job | running | 5s       | 2013-09-03 14:15:51 -0400 | 2013-09-03 14:15:56 -0400 |
  | loop_job | running | 5s       | 2013-09-03 14:15:38 -0400 | 2013-09-03 14:15:38 -0400 |
  +----------+---------+----------+---------------------------+---------------------------+
</code>

Add another instance of a job
-----------------------------

<code>
**add work\_job\_2 every 2s**
&gt; Added job work\_job\_2
</code>

<code>
list
&gt; +------------+---------+----------+---------------------------+---------------------------+
| Name       | Status  | Interval | Last Run                  | Next Run                  |
+------------+---------+----------+---------------------------+---------------------------+
| work\_job   | running | 5s       | 2013-09-03 14:20:36 -0400 | 2013-09-03 14:20:41 -0400 |
| loop\_job   | running | 5s       | 2013-09-03 14:15:38 -0400 | 2013-09-03 14:15:38 -0400 |
| work\_job\_2 | running | 2s       | 2013-09-03 14:20:37 -0400 | 2013-09-03 14:20:39 -0400 |
+------------+---------+----------+---------------------------+---------------------------+
</code>

Delete job
----------

<code>
delete work\_job\_2
&gt; Deleted job work\_job\_2
</code>

Pause jobs
----------

<code>
pause work_job
&gt; Paused job work_job
</code>

Resume jobs
----------

<code>
resume work_job
&gt; Resumed job work_job
</code>