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

```
help
> Valid commands: list, add, delete, pause, resume, help, jobs
```

List schedulable jobs
---------------------

```
jobs
> +--------+---------------------+
| Work   | Displays some text. |
| Looper | Displays some text. |
+--------+---------------------+
```

Add instance of a job
---------------------

```
add work\_job every 5s Work
> Added job work\_job
```

```
add loop_job in 5s Looper
> Added job loop\_job
```

List scheduled jobs
-------------------
```
list
> +----------+---------+----------+---------------------------+---------------------------+
| Name     | Status  | Interval | Last Run                  | Next Run                  |
+----------+---------+----------+---------------------------+---------------------------+
| work_job | running | 5s       | 2013-09-03 14:15:51 -0400 | 2013-09-03 14:15:56 -0400 |
| loop_job | running | 5s       | 2013-09-03 14:15:38 -0400 | 2013-09-03 14:15:38 -0400 |
+----------+---------+----------+---------------------------+---------------------------+
```

Add another instance of a job
-----------------------------

```
add work\_job\_2 every 2s
> Added job work\_job\_2
```

```
list
> +------------+---------+----------+---------------------------+---------------------------+
| Name       | Status  | Interval | Last Run                  | Next Run                  |
+------------+---------+----------+---------------------------+---------------------------+
| work\_job   | running | 5s       | 2013-09-03 14:20:36 -0400 | 2013-09-03 14:20:41 -0400 |
| loop\_job   | running | 5s       | 2013-09-03 14:15:38 -0400 | 2013-09-03 14:15:38 -0400 |
| work\_job\_2 | running | 2s       | 2013-09-03 14:20:37 -0400 | 2013-09-03 14:20:39 -0400 |
+------------+---------+----------+---------------------------+---------------------------+
```

Delete job
----------

```
delete work\_job\_2
> Deleted job work\_job\_2
```

Pause jobs
----------

```
pause work_job
> Paused job work_job
```

Resume jobs
----------

```
resume work_job
> Resumed job work_job
```
