CREATE DATABASE IF NOT EXISTS mydatabase;
USE mydatabase;

CREATE TABLE IF NOT EXISTS visitors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    count INT NOT NULL DEFAULT 0
);


INSERT INTO visitors (id, count) VALUES (1, 0);


CREATE TABLE IF NOT EXISTS gifs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(255) NOT NULL
);


INSERT INTO gifs (url) VALUES
('https://c.tenor.com/-VFGlrBlcSwAAAAd/tenor.gif'),
('https://c.tenor.com/0fI0vd8FEsoAAAAd/tenor.gif'),
('https://c.tenor.com/2GeIejx2hbYAAAAd/tenor.gif'),
('https://c.tenor.com/4NLfMi7XI7kAAAAd/tenor.gif'),
('https://c.tenor.com/DXBMFHbQ0AAAAAAd/tenor.gif'),
('https://c.tenor.com/KMuLEm4XapgAAAAd/tenor.gif'),
('https://c.tenor.com/WcoyIUKbg5oAAAAd/tenor.gif'),
('https://media1.tenor.com/m/306nYrZprbEAAAAd/timon-lion-king.gif'),
('https://media1.tenor.com/m/G34k5QDbCA0AAAAC/timon-and-pumbaa-cry.gif'),
('https://media1.tenor.com/m/J4F181cEBV0AAAAd/the-lion-king-timon.gif'),
('https://media1.tenor.com/m/Kr7oesiWatIAAAAd/lion-king-oh-the-shame.gif'),
('https://media1.tenor.com/m/v6w_poAU3LoAAAAd/achin-for-some-bacon-lion-king.gif');
