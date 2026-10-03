# Resume Analyzer & Career Recommendation System — Working Demo

A working implementation of the OOP mini project from the slides:
**HTML/CSS/JS front end → Spring Boot REST API → MySQL**, all in Java.

---

## 1. What's inside

```
resume-analyzer/
├── pom.xml
├── mysql_schema.sql                  (reference only — Hibernate creates this for you)
├── src/main/java/com/oop/resumeanalyzer/
│   ├── ResumeAnalyzerApplication.java
│   ├── model/         User, Resume, JobRole (abstract), TechnicalRole, ManagerialRole, Report
│   ├── service/       Analyzer (abstract), SkillAnalyzer, ReportGenerator (abstract),
│   │                  TechnicalReportGenerator, ManagerialReportGenerator,
│   │                  ReportGeneratorFactory, ResumeAnalyzerService
│   ├── repository/    Spring Data JPA repositories (talk to MySQL)
│   ├── controller/    ResumeController (REST API)
│   ├── dto/           Request/response objects for the API
│   └── config/        DataSeeder (loads sample job roles on first run)
└── src/main/resources/
    ├── application.properties        (MySQL connection settings)
    └── static/        index.html, style.css, script.js   <- the HTML/CSS/JS front end
```

## 2. How the OOP concepts map to code (for your viva)

| Concept | Where it lives |
|---|---|
| **Encapsulation** | `User`, `Resume` — private fields, public getters/setters, `updateProfile()` |
| **Abstraction** | `Analyzer.analyze()` and `ReportGenerator.generateReport()` are abstract methods with no implementation in the base class |
| **Inheritance** | `TechnicalRole` and `ManagerialRole` both `extends JobRole` |
| **Polymorphism** | `ReportGeneratorFactory` returns a `ReportGenerator`, but which `generateReport()` actually runs depends on whether the object is a `TechnicalReportGenerator` or `ManagerialReportGenerator` (runtime dispatch) |
| **Single Responsibility** | `SkillAnalyzer` only compares skills, `ReportGenerator` only formats output, `ResumeAnalyzerService` only orchestrates the flow |

The working flow from your slide maps directly:

```
User enters resume details  →  index.html form
System stores candidate     →  UserRepository / ResumeRepository (MySQL)
Skills extracted            →  request.getSkills()
Compared with requirements  →  SkillAnalyzer.analyze()
Score calculated            →  AnalysisResult.matchPercentage
Missing skills identified   →  AnalysisResult.missingSkills
Report generated            →  ReportGenerator.generateReport()  (saved to `report` table)
```

## 3. Prerequisites

You need these installed on **your own machine** (not this sandbox, which has no internet
access to Maven Central or a MySQL server):

- JDK 17+
- Maven 3.8+ (or use the included `mvnw` if you add one — plain `mvn` works fine)
- MySQL 8.x running locally

## 4. Setup

1. **Start MySQL** and make sure you know your root password (or create a dedicated user).
2. Open `src/main/resources/application.properties` and update:
   ```properties
   spring.datasource.username=root
   spring.datasource.password=YOUR_MYSQL_PASSWORD
   ```
   You don't need to create the database or tables by hand — `createDatabaseIfNotExist=true`
   and `spring.jpa.hibernate.ddl-auto=update` do it for you on first run. `mysql_schema.sql`
   is included only so you can show the underlying table structure if asked.
3. From the `resume-analyzer` folder, run:
   ```bash
   mvn spring-boot:run
   ```
   (First run downloads dependencies from Maven Central, so you need internet access once.)
4. Open **http://localhost:8080** in your browser — that's the HTML/CSS/JS front end,
   served directly by Spring Boot.

## 5. Using the demo

1. Fill in a candidate name and (optionally) email.
2. Pick a target role — the required skills for that role appear underneath the form.
3. Type in the candidate's current skills, comma-separated (e.g. `Java, HTML, CSS, Git`).
4. Click **Generate report** — the right-hand panel prints a report with:
   - a compatibility percentage and bar,
   - matched vs. missing skills as chips,
   - a terminal-style block that mirrors the `CareerReport.java` sample output from your slides.

Every submission is persisted: `app_user` + `resume` (candidate), and `report`
(the generated analysis) — so the "Data Management" pillar from your Introduction slide is real,
not just in-memory.

## 6. Sample roles already seeded

| Role | Category | Required skills |
|---|---|---|
| Software Developer | Technical | Java, SQL, Git, Data Structures, OOP |
| Frontend Developer | Technical | HTML, CSS, JavaScript, React, Git |
| Data Analyst | Technical | SQL, Python, Excel, Data Structures, Statistics |
| Project Manager | Managerial | Communication, Agile, Risk Management, Budgeting, Leadership |
| Team Lead | Managerial | Java, Leadership, Agile, Communication, Mentoring |

Try candidate skills `Java, HTML, CSS, React` against **Software Developer** to reproduce
something close to the 25%-match example from your slides.

## 7. Extending it (matches your "Future Scope" slide)

- Swap the comma-separated skills box for a resume file upload + basic parsing.
- Add a `LearningResource` model linked to each missing skill (learning-path recommender).
- Add a login page in front of `User` for multi-user history.
