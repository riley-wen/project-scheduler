# Project Scheduler
A project to track, record and export a project's building process and documentation.

Built for CS19300 final project.
## References

| | |
| --- | --- |
| Github | github.com/user/project-scheduler |
## Dependencies

| Name | Version | Link |
| --- | --- | --- |
| Flutter | 3.11.3 |  |
| flutter_quill | 11.5.0 | [https://pub.dev/packages/flutter_quill](https://pub.dev/packages/flutter_quill) |
| google_fonts | 8.2.1 | [https://pub.dev/packages/google_fonts](https://pub.dev/packages/google_fonts) |
| localstore | 1.4.0 | [https://pub.dev/packages/localstorage](https://pub.dev/packages/localstorage) |
| shadcn_ui | 0.57.4 | [https://pub.dev/packages/shadcn_ui](https://pub.dev/packages/shadcn_ui) |

## System Design
The main feature, which are projects and their sub-units, are locally stored based on the category of data rather than together. By storing an ID for each project and project unit, the program can easily choose between receiving basic information about a project via ID or looking through all separate local files to construct the full detailed project and its sub-units, similar to a relational database except in JSON format.