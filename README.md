# iOS 스터디 Git 사용 가이드

## 프로젝트 개요
- 본 저장소는 UMC 9기 Cassiopeia 지부 iOS 스터디를 위한 레포지토리입니다.
- 스터디원들은 각자의 폴더에서 작업을 진행하며, 주차별 미션을 수행합니다.
- PR(Pull Request)을 활용하여 코드 리뷰를 진행하고, 최종적으로 study 브랜치에 병합합니다.

## 1️. 폴더 구조

각 팀원은 자신의 폴더에서만 작업을 진행합니다.
주차별 미션은 개인 폴더 내에서 관리됩니다.

```
iOS/
 ┣ 📂 MemberA/
 ┃ ┗ 📂 MegaBox/
 ┣ 📂 MemberA/
 ┃ ┗ 📂 MegaBox/
 ┣ 📂 MemberC/
 ┃ ┗ 📂 MegaBox/
 ┣ 📂 MemberD/
 ┃ ┗ 📂 MegaBox/
 ┣ 📂 .gitignore
 ┣ 📂 README.md
 ┗ 📂 .github/
 ```

## 2️. Git 브랜치 전략

각자의 브랜치에서 작업 후 PR을 통해 study 브랜치로 병합합니다.

#### 브랜치 네이밍 규칙

	feature/{팀원명}-mission-{N}

	예시:
    feature/river-mission-1
    feature/daisy-mission-2

## 3️. Git 사용 가이드

### 1. 저장소 클론 (최초 1회)
```bash
git clone https://github.com/HSU-Makeus-Challenge-9th/iOS.git
cd iOS
git switch study  # study 브랜치로 이동
```

### 2. 최신 상태 유지

study 브랜치의 최신 상태를 유지해야 합니다.
```bash
$ git switch study
$ git pull origin study
```

### 3. 주차별 미션 브랜치 생성

각자의 미션을 수행할 새 브랜치를 생성합니다.
```bash
$ git switch -c feature/{팀원명}-mission-{N}
```

### 4. 작업 진행 후 커밋

작업이 끝나면 변경된 파일을 커밋합니다.
```bash
$ git add .
$ git commit -m "feat: {변경 사항 요약}"
```
아래 커밋 컨벤션을 참고하여 적절한 커밋 메시지 작성
#### 커밋 컨벤션
```
feat: 새로운 기능
fix: 버그 수정
refactor: 코드 개선
style: 스타일 변경 (기능 변화 없음)
docs: 문서 추가/수정
chore: 비기능적 변경 사항(빌드 설정 변경 등)
```

예시: git commit -m "feat: 로그인 화면 UI 구현"

### 5. 원격 저장소에 푸시
```bash
$ git push origin feature/{닉네임}-mission-{N}
```

예시: git push origin feature/river-mission-1

### 6. PR(Pull Request) 생성
	1.	GitHub 저장소에서 Pull Requests 탭으로 이동
	2.	New Pull Request 버튼 클릭
	3.	base 브랜치를 study로 설정하고, compare 브랜치를 feature/{팀원명}-mission-{N}로 선택
	4.	PR 템플릿을 따라 PR 내용 작성 후 제출
	5.	충돌 없으면 study 브랜치에 병합

### 7. 병합 후 브랜치 삭제 및 정리

병합된 브랜치는 더 이상 필요 없으므로 삭제하고, 다음 미션을 위해 study 브랜치를 최신 상태로 유지합니다.
```bash
$ git switch study
$ git pull origin study
$ git branch -D feature/{팀원명}-mission-{N}
# 아래 명령어는 PR 후 브랜치 삭제와 동일한 기능
$ git push origin --delete feature/{팀원명}-mission-{N}
```

## Git 작업 단계 및 명령어

| 작업 단계           | 명령어 |
|-------------------|-------------------------------|
| **저장소 클론**     | `git clone <repo-url>` |
| **최신 상태 유지**  | `git pull origin study` |
| **새 브랜치 생성**   | `git checkout -b feature/{팀원명}-mission-{N}` |
| **작업 후 커밋**     | `git add .` → `git commit -m "메시지"` |
| **원격 저장소에 푸시** | `git push origin feature/{팀원명}-mission-{N}` |
| **PR 생성**       | GitHub에서 `study` 브랜치로 PR 생성 |
| **병합 후 정리**   | `git branch -D feature/{팀원명}-mission-{N}` → `git push origin --delete feature/{팀원명}-mission-{N}` |