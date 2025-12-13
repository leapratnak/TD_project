-- Create Users table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE Users (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(256) NOT NULL UNIQUE,
        Username NVARCHAR(100) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(512) NOT NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END

-- Create PasswordResets table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PasswordResets' AND xtype='U')
BEGIN
    CREATE TABLE PasswordResets (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL,
        OTP NVARCHAR(32) NOT NULL,
        ExpiresAt DATETIME2 NOT NULL,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_PasswordResets_Users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
    );
END
CREATE TABLE Users (
Id INT IDENTITY(1,1) PRIMARY KEY,
Username NVARCHAR(200) NOT NULL,
Email NVARCHAR(256) NOT NULL UNIQUE,
PasswordHash NVARCHAR(512) NOT NULL,
CreatedAt DATETIME NOT NULL
);


CREATE TABLE PasswordResets (
Id INT IDENTITY(1,1) PRIMARY KEY,
UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
OTP NVARCHAR(10) NOT NULL,
ExpiresAt DATETIME NOT NULL
);

-- Create Categories table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categories' AND xtype='U')
BEGIN
    CREATE TABLE Categories (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL UNIQUE,
        Description NVARCHAR(500),
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END