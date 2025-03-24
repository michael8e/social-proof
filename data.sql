USE c_cs108_rrb;
SET @@auto_increment_increment=1;

DROP TABLE IF EXISTS quizzes;
CREATE TABLE quizzes (
	zID INT,
    name text,
    description TEXT,
    uID INT,
    time DateTime,
    random Boolean,
    multiple Boolean,
    immediate Boolean
);
INSERT INTO quizzes VALUES
	(0,"Test Quiz","First test quiz. One math question.", 0, "2014-11-10 00:00:03", false, false, false),
	(1,"Stanford Quiz","Test quiz about Stanford info.", 0, "2014-11-10 00:00:02", true, false, false),
	(2,"CS quiz","Quiz on basic CS.", 0, "2014-11-10 00:00:01", false, false, false);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
	zID INT,
	sID INT,
	question TEXT,
	type INT
);
INSERT INTO questions VALUES
	(0, 0, "What is 2+2?", 3),
	(0, 1, "Where is Stanford?", 3),
	(1, 0, "What's the most popular major at Stanford?", 1),
	(1, 1, "Axe'n'###", 2),
	(1, 2, "What was Leland Stanford Jr.'s father's first name?", 3),
	(1, 3, "", 4),
	(1, 4, "Name the 4 cardinal directions.", 5),
	(1, 5, "Who are Stanford Alumni?", 6),
	(2, 0, "What's the main languages from CS107 and CS108? (with the ++)", 5),
	(2, 1, "The most popular open-source database is My###", 2),
	(2, 2, "Which one isn't cool?", 3);


DROP TABLE IF EXISTS choices;
CREATE TABLE choices (
	zID INT,
	sID INT,
	choice TEXT
);
INSERT INTO choices VALUES
	(0, 0, "0"),
	(0, 0, "1"),
	(0, 0, "4"),
	(0, 0, "5"),
	(0, 1, "Alaska"),
	(0, 1, "Germany"),
	(0, 1, "South America"),
	(0, 1, "Northern CA"),
	(1, 2, "Ben"),
	(1, 2, "Leland"),
	(1, 2, "Snoop"),
	(1, 2, "Greg"),
	(1, 3, "http://upload.wikimedia.org/wikipedia/commons/1/1e/Top_of_the_Hoover_Tower.jpg"),
	(1, 4, ""),
	(1, 4, ""),
	(1, 4, ""),
	(1, 4, ""),
	(1, 5, "Herbert Hoover"),
	(1, 5, "Reese Witherspoon"),
	(1, 5, "Harry Potter"),
	(1, 5, "Charles Schwab"),
	(2, 0, ""),
	(2, 0, ""),
	(2, 2, "Hacking"),
	(2, 2, "Coding"),
	(2, 2, "Investment banking"),
	(2, 2, "Software Developing");


DROP TABLE IF EXISTS answers;
CREATE TABLE answers (
	zID INT,
	sID INT,
	answer TEXT
);
INSERT INTO answers VALUES
	(0, 0, "4"),
	(0, 1, "Northern CA"),
	(1, 0, "Computer Science"),
	(1, 1, "Palm"),
	(1, 2, "Leland"),
	(1, 3, "Hoover Tower"),
	(1, 4, "North"),
	(1, 4, "South"),
	(1, 4, "East"),
	(1, 4, "West"),
	(1, 5, "Herbert Hoover"),
	(1, 5, "Reese Witherspoon"),
	(1, 5, "Charles Schwab"),
	(2, 0, "Java"),
	(2, 0, "C++"),
	(2, 1, "SQL"),
	(2, 2, "Investment banking");

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	uID INT AUTO_INCREMENT PRIMARY KEY,
	username TEXT,
	password TEXT,
	salt TEXT
);
INSERT INTO users (username, password, salt) VALUES
	("ryan", "5adc845bb351398c4ab1b35f5b82c5648904d703", "f874476d581ef82e6226e37247c6ab2c810ad3c6"),
	("danielle", "d8210fd2865b637863e1af2760bac929fc8cb972", "6e6ec6bba405095f403d9575393f2ea5f1792cc8"),
	("amy", "620577c0f6d2128d299d68187c80aacf5cea0408", "31732e02c898aa830b4463687b5430bc133a9c98"),
	("test4", "544e450761466d5b8e705c0edbf4c183b27e97f1", "a9fdfceff682c39ad5689db2ba350e211a0d8f38"),
	("test5", "e88e922788f40b2591b529d827f1e2319aaf14ab", "66d6bf1da30e4cca8440408fb1ec07ce2fd3d196"),
	("test6", "7276250ded7b420dc8ce6389bf71c7659b91362b", "9e3fc11b74cdaf4abd8e27644594e63d34f7035b"),
	("test7", "650de3de201bbee056f35357043e12805a6406db", "4f9784d417002b81e4068a382d42b7874907cc2b"),
	("test8", "7d63e727ee2cd55a082eccf016cac0d283891383", "58e386bec0ef76809dbc3563f96084aceac8cc32"),
	("test9", "678e9eccaefcff6b3a18ad1b8ccabc781db204a7", "a8766d94ba4e403969112881b12b4a52a563adef");

DROP TABLE IF EXISTS administrators;
CREATE TABLE administrators (
	uID INT
);
INSERT INTO administrators (uID) VALUES
	(1),
	(2),
	(3);

DROP TABLE IF EXISTS announcements;
CREATE TABLE announcements (
	uID INT,
	announcement TEXT,
	timestamp DateTime
);
INSERT INTO announcements VALUES
	(0, "Happy Thanksgiving!", "1980-11-10 00:00:01"),
	(1, "Danielle writes an announcement!", "1980-11-10 00:00:01");

DROP TABLE IF EXISTS scores; 
CREATE TABLE scores (
	uID INT,
	zID INT,
	score INT,
	possible INT,
	time DateTime,
	timeTaken LONG
);
INSERT INTO scores VALUES
	(0, 0, 0, 0, "1980-11-10 00:00:01", 0);
	
DROP TABLE IF EXISTS friendships;
CREATE TABLE friendships (
	uID INT,
	friendID INT
);
-- we are all friends with each other
INSERT INTO friendships VALUES
	(1, 2),
	(1, 3),
	(2, 1),
	(2, 3),
	(3, 1),
	(3, 2);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	fromID INT,
	toID INT
);
-- some people want to be friends with us!
INSERT INTO friend_requests VALUES
	(5, 1),
	(6, 2),
	(7, 3);

-- data isn't true -- only for test purposes
DROP TABLE IF EXISTS achievements; 
CREATE TABLE achievements (
	uID INT,
	type INT,
	name Text
);
INSERT INTO achievements VALUES
	(1, 0, "Fake Make 1"),
	(1, 0, "Fake Make 2"),
	(1, 0, "Fake Make 3"),
	(1, 0, "Fake Make 4"),
	(1, 0, "Fake Make 5"),
	(1, 0, "Fake Make 6"),
	(1, 0, "Fake Make 7"),
	(1, 0, "Fake Make 8"),
	(1, 0, "Fake Make 9"),
	(1, 0, "Fake Make 10"),
	(1, 1, "Fake Take 1"),
	(1, 1, "Fake Take 2"),
	(1, 1, "Fake Take 3"),
	(1, 1, "Fake Take 4"),
	(1, 1, "Fake Take 5"),
	(1, 1, "Fake Take 6"),
	(1, 1, "Fake Take 7"),
	(1, 1, "Fake Take 8"),
	(1, 1, "Fake Take 9"),
	(1, 1, "Fake Take 10"),
	(1, 2, "Fake Greatest"),
	(1, 3, "Fake Practice"),
	(3, 0, "Fake Make 1"),
	(3, 0, "Fake Make 2"),
	(3, 0, "Fake Make 3"),
	(3, 0, "Fake Make 4"),
	(3, 0, "Fake Make 5"),
	(3, 0, "Fake Make 6"),
	(3, 0, "Fake Make 7"),
	(3, 0, "Fake Make 8"),
	(3, 0, "Fake Make 9"),
	(3, 0, "Fake Make 10"),
	(3, 1, "Fake Take 1"),
	(3, 1, "Fake Take 2"),
	(3, 1, "Fake Take 3"),
	(3, 1, "Fake Take 4"),
	(3, 1, "Fake Take 5"),
	(3, 1, "Fake Take 6"),
	(3, 1, "Fake Take 7"),
	(3, 1, "Fake Take 8"),
	(3, 1, "Fake Take 9"),
	(3, 1, "Fake Take 10"),
	(3, 2, "Fake Greatest"),
	(3, 3, "Fake Practice"),
	(5, 0, "Fake Make 1"),
	(5, 0, "Fake Make 2"),
	(5, 0, "Fake Make 3"),
	(5, 0, "Fake Make 4"),
	(5, 0, "Fake Make 5"),
	(5, 0, "Fake Make 6"),
	(5, 0, "Fake Make 7"),
	(5, 0, "Fake Make 8"),
	(5, 0, "Fake Make 9"),
	(5, 0, "Fake Make 10"),
	(5, 1, "Fake Take 1"),
	(5, 1, "Fake Take 2"),
	(5, 1, "Fake Take 3"),
	(5, 1, "Fake Take 4"),
	(5, 1, "Fake Take 5"),
	(5, 1, "Fake Take 6"),
	(5, 1, "Fake Take 7"),
	(5, 1, "Fake Take 8"),
	(5, 1, "Fake Take 9"),
	(5, 1, "Fake Take 10"),
	(5, 2, "Fake Greatest"),
	(5, 3, "Fake Practice");
	
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	mID INT AUTO_INCREMENT PRIMARY KEY,
	fromID INT,
	toID INT,
	content TEXT,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	is_read BOOLEAN DEFAULT FALSE,
	is_archived BOOLEAN DEFAULT FALSE
);

INSERT INTO messages (fromID, toID, content) VALUES
(1, 2, "hi danielle, message from ryan!"),
(1, 3, "hi amy, message from ryan!"),
(2, 3, "hi amy, message from danielle!"),
(2, 1, "hi ryan, message from danielle!"),
(3, 1, "hi ryan, message from amy!"),
(3, 2, "hi danielle, message from amy!");

DROP TABLE IF EXISTS challenges;
CREATE TABLE challenges (
	cID INT AUTO_INCREMENT PRIMARY KEY,
	fromID INT,
	toID INT,
	zID INT,
	content TEXT,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	completed BOOLEAN DEFAULT FALSE
);

INSERT INTO challenges (fromID, toID, zID, content) VALUES
	(1, 2, 1, "hey danielle, try this quiz! -ryan"),
	(2, 3, 1, "hey amy, try this quiz! -danielle"),
	(3, 1, 1, "hey ryan, try this quiz! -amy");