USE [td_flutter]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 12/14/2025 1:09:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PasswordResets]    Script Date: 12/14/2025 1:09:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordResets](
	[UserId] [int] NOT NULL,
	[OTP] [varchar](6) NOT NULL,
	[ExpiresAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 12/14/2025 1:09:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CategoryId] [int] NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[ImageUrl] [nvarchar](1000) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/14/2025 1:09:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[Username] [varchar](255) NOT NULL,
	[PasswordHash] [varchar](255) NOT NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (1, N'Drink', N'Can', CAST(N'2025-12-12T18:05:50.293' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (4, N'FastFood', N'Cheess', CAST(N'2025-12-12T18:52:26.663' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (5, N'ផ្លែឈើ', N'ផ្អែម', CAST(N'2025-12-12T23:33:14.070' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (6, N'សម្ភារសិស្សា', N'សម្រាប់វិទ្យាល័យ', CAST(N'2025-12-13T00:44:34.373' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (7, N'គ្រឿងទេស', N'ធ្វើម្ហូប', CAST(N'2025-12-13T00:45:48.460' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (8, N'HealthyFood', N'For breakfast', CAST(N'2025-12-13T00:46:34.767' AS DateTime))
GO
INSERT [dbo].[Categories] ([id], [name], [description], [created_at]) VALUES (9, N'Computer', N'Eletronic', CAST(N'2025-12-14T11:59:56.147' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
INSERT [dbo].[PasswordResets] ([UserId], [OTP], [ExpiresAt]) VALUES (3, N'759776', CAST(N'2025-12-14T05:52:34.200' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Products] ON 
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (1, N'Burger', N'cheess', 1, CAST(3.00 AS Decimal(18, 2)), N'/images/1765683581686.png', CAST(N'2025-12-12T23:58:29.293' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (3, N'Pen003', N'for children', 4, CAST(1.00 AS Decimal(18, 2)), N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX3MQcBAXE1gu9SWfwvyQuSK74XW8vtXrXhg&s', CAST(N'2025-12-13T00:38:04.830' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (15, N'Coca Cola', N'Soft drink 330ml', 1, CAST(0.75 AS Decimal(18, 2)), N'/images/1765683568047.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (16, N'Pepsi', N'Soft drink 330ml', 1, CAST(0.70 AS Decimal(18, 2)), N'/images/1765683558519.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (17, N'Sprite', N'Lemon soft drink 330ml', 1, CAST(0.72 AS Decimal(18, 2)), N'/images/1765683550704.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (18, N'Fanta Orange', N'Orange flavor drink', 1, CAST(0.68 AS Decimal(18, 2)), N'/images/1765683541737.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (19, N'Red Bull', N'Energy drink 250ml', 1, CAST(1.20 AS Decimal(18, 2)), N'/images/1765683532930.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (20, N'Sting Energy', N'Strawberry flavor', 1, CAST(0.90 AS Decimal(18, 2)), N'/images/1765683522775.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (21, N'Angkor Water', N'Mineral drinking water', 1, CAST(0.25 AS Decimal(18, 2)), N'/images/1765683515127.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (22, N'Samurai Energy', N'Energy drink 320ml', 1, CAST(1.00 AS Decimal(18, 2)), N'/images/1765683505778.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (23, N'Carabao', N'Energy drink Thailand', 1, CAST(0.95 AS Decimal(18, 2)), N'/images/1765683497814.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (24, N'Oishi Green Tea', N'Honey lemon green tea', 1, CAST(0.85 AS Decimal(18, 2)), N'/images/1765683486556.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (25, N'Chicken Fried Rice', N'Fried rice with chicken', 7, CAST(2.50 AS Decimal(18, 2)), N'/images/1765683479126.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (26, N'Beef Fried Rice', N'Fried rice with beef', 7, CAST(2.80 AS Decimal(18, 2)), N'/images/1765683468133.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (27, N'Seafood Fried Rice', N'Shrimp and squid rice', 7, CAST(3.20 AS Decimal(18, 2)), N'/images/1765683459224.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (28, N'បាយសាច់មាន់', N'Khmer style noodles', 7, CAST(2.20 AS Decimal(18, 2)), N'/images/1765683450074.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (29, N'Beef Lok Lak', N'Khmer Lok Lak with egg', 7, CAST(3.80 AS Decimal(18, 2)), N'/images/1765683434843.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (30, N'Chicken Soup', N'Hot chicken soup bowl', 7, CAST(2.00 AS Decimal(18, 2)), N'/images/1765683326972.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (31, N'Pork BBQ', N'Grilled pork skewers', 7, CAST(1.50 AS Decimal(18, 2)), N'/images/1765683315350.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (32, N'Beef Steak', N'Beef steak with sauce', 7, CAST(5.50 AS Decimal(18, 2)), N'/images/1765682622492.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (33, N'Spring Rolls', N'Fresh vegetable rolls', 7, CAST(1.20 AS Decimal(18, 2)), N'/images/1765682613493.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (34, N'Khmer Curry', N'Traditional Khmer curry', 7, CAST(3.00 AS Decimal(18, 2)), N'/images/1765682603695.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (35, N'iPhone Charger', N'20W fast charging', 8, CAST(12.00 AS Decimal(18, 2)), N'/images/1765682595841.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (36, N'USB-C Cable', N'1 meter fast cable', 8, CAST(3.50 AS Decimal(18, 2)), N'/images/1765682585824.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (37, N'Phone Case', N'Shockproof case', 8, CAST(4.00 AS Decimal(18, 2)), N'/images/1765682576619.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (38, N'Wireless Mouse', N'Ergonomic design', 8, CAST(6.50 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1587829741301-dc798b83add3', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (39, N'Bluetooth Speaker', N'Portable speaker', 8, CAST(15.00 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (40, N'Laptop Cooling Pad', N'USB powered cooling', 8, CAST(7.80 AS Decimal(18, 2)), N'/images/1765682568250.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (41, N'Keyboard', N'USB mechanical keyboard', 8, CAST(10.00 AS Decimal(18, 2)), N'/images/1765682556936.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (42, N'32GB Flash Drive', N'USB flash storage', 8, CAST(5.00 AS Decimal(18, 2)), N'/images/1765682544452.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (43, N'Power Bank 10000mAh', N'Portable battery', 8, CAST(9.50 AS Decimal(18, 2)), N'/images/1765682518014.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (44, N'Headphones', N'Noise reduction', 8, CAST(8.20 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1492684223066-81342ee5ff30', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (45, N'អាវយឺត', N'Cotton t-shirt', 4, CAST(5.00 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (46, N'Women Dress', N'Fashion summer dress', 4, CAST(12.00 AS Decimal(18, 2)), N'/images/1765682507266.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (47, N'Jeans Pants', N'Blue denim jeans', 4, CAST(15.00 AS Decimal(18, 2)), N'/images/1765682490953.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (48, N'Men Shoes', N'Running sport shoes', 4, CAST(18.00 AS Decimal(18, 2)), N'/images/1765682483918.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (49, N'Women Sandals', N'Comfort sandals', 4, CAST(7.00 AS Decimal(18, 2)), N'/images/1765682474039.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (50, N'Cap Hat', N'Black stylish cap', 4, CAST(3.50 AS Decimal(18, 2)), N'/images/1765682466285.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (51, N'Backpack', N'Waterproof bag', 4, CAST(9.00 AS Decimal(18, 2)), N'/images/1765682456662.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (52, N'Sunglasses', N'UV protection', 4, CAST(6.00 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (53, N'Hoodie Jacket', N'Warm hoodie', 4, CAST(14.00 AS Decimal(18, 2)), N'/images/1765682369216.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (54, N'Sport Shorts', N'Breathable shorts', 4, CAST(4.00 AS Decimal(18, 2)), N'/images/1765682380251.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (55, N'Soap Bar', N'Natural bath soap', 5, CAST(1.00 AS Decimal(18, 2)), N'/images/1765682414961.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (56, N'Shampoo', N'Anti-dandruff shampoo', 5, CAST(2.50 AS Decimal(18, 2)), N'/images/1765682425009.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (57, N'Toothpaste', N'Mint flavor toothpaste', 5, CAST(1.20 AS Decimal(18, 2)), N'/images/1765682407178.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (58, N'Lotion', N'Skin care lotion', 5, CAST(3.00 AS Decimal(18, 2)), N'/images/1765682398480.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (59, N'Perfume', N'Fresh perfume', 5, CAST(6.50 AS Decimal(18, 2)), N'/images/1765682389961.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (60, N'Face Wash', N'Moisturizing face wash', 5, CAST(2.30 AS Decimal(18, 2)), N'/images/1765682351210.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (61, N'Hand Sanitizer', N'Instant sanitizer', 5, CAST(1.00 AS Decimal(18, 2)), N'/images/1765682340100.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (62, N'Hair Conditioner', N'Smooth conditioner', 5, CAST(2.80 AS Decimal(18, 2)), N'/images/1765682331027.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (63, N'Makeup Kit', N'Full beauty set', 5, CAST(10.00 AS Decimal(18, 2)), N'/images/1765682312630.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (64, N'Deodorant Spray', N'Long lasting fragrance', 5, CAST(3.20 AS Decimal(18, 2)), N'/images/1765682079843.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (65, N'សៀវភៅកត់ត្រា', N'100 pages notebook', 6, CAST(0.80 AS Decimal(18, 2)), N'/images/1765682041716.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (66, N'ប៊ិចខៀវ', N'Ballpoint pen blue', 6, CAST(0.20 AS Decimal(18, 2)), N'/images/1765682028415.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (67, N'Pencil HB', N'Wooden HB pencil', 6, CAST(0.10 AS Decimal(18, 2)), N'/images/1765681996701.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (68, N'Marker', N'Black whiteboard marker', 6, CAST(0.50 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1556911220-bff31c812dba', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (69, N'A4 Paper Pack', N'500 sheets A4', 6, CAST(4.00 AS Decimal(18, 2)), N'/images/1765681986885.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (70, N'Stapler', N'Small office stapler', 6, CAST(1.50 AS Decimal(18, 2)), N'/images/1765681974904.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (71, N'Ruler 30cm', N'Plastic ruler', 6, CAST(0.40 AS Decimal(18, 2)), N'/images/1765681962994.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (72, N'Glue Stick', N'Strong glue stick', 6, CAST(0.30 AS Decimal(18, 2)), N'/images/1765681948309.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (73, N'Calculator', N'Basic calculator', 6, CAST(3.00 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1593642634315-48f5414c3ad9', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (74, N'Envelope Pack', N'20 envelopes', 6, CAST(0.60 AS Decimal(18, 2)), N'/images/1765681938533.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (75, N'Whiteboard', N'Medium size board', 6, CAST(7.00 AS Decimal(18, 2)), N'/images/1765681928882.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (76, N'Office Chair', N'Comfort swivel chair', 6, CAST(25.00 AS Decimal(18, 2)), N'/images/1765681916787.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (77, N'Desk Lamp', N'LED study lamp', 6, CAST(6.00 AS Decimal(18, 2)), N'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (78, N'Paper Cutter', N'Office paper cutter', 6, CAST(12.00 AS Decimal(18, 2)), N'/images/1765681903228.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
INSERT [dbo].[Products] ([Id], [Name], [Description], [CategoryId], [Price], [ImageUrl], [CreatedAt]) VALUES (79, N'Banner Food', N'Document storage folder', 6, CAST(1.10 AS Decimal(18, 2)), N'/images/1765633829094.png', CAST(N'2025-12-13T00:53:18.567' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (2, N'Tong@gmail.com', N'tongheng', N'$2b$10$btnplDu29VdBQXhQH/sAgOikGqAngNv0hdLTz.8WsAUn7x/yxODG2', CAST(N'2025-12-12T15:59:51.163' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (3, N'leaprathanak@gmail.com', N'ratnak', N'$2b$10$xa8xsz80x6Mm.XbZdhF0P.VVwh5fpuZA4LMmS4k5RfBfTc3T8U8Be', CAST(N'2025-12-12T17:15:29.007' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (4, N'sovan@gmail.com', N'Chea Sovan', N'$2b$10$XbGMHNeG3xt56VZozayJousfHc5TeU2os.oR75LQpQHLRqjvl/HqG', CAST(N'2025-12-14T12:13:07.453' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (5, N'henglina@gmail.com', N'Heng Lina', N'$2b$10$hYY3pZ53W3G2AyJCfxARqunsEOp6TJRKXO8nQOkS8ukywHKrMQtJm', CAST(N'2025-12-14T12:19:35.263' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (6, N'sengthida@gmail.com', N'Seng Thida', N'$2b$10$/SFA8ifGCWzoqWxW7BR4NOs.nSkUs7VXNncdbbiZ69vs0hPmdmz16', CAST(N'2025-12-14T12:22:00.283' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (7, N'vimean@gmail.com', N'Sok Vimean', N'$2b$10$qylasvjdZI0R6ByTsSlXAujvs0HZp8bLCER2KPiwFefJ9MqPi8EL6', CAST(N'2025-12-14T12:29:29.003' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (8, N'thearith@gmail', N'Thea Rith', N'$2b$10$.8mtE.gq2NnOxhQHGWkma.y8ILyYNMLgf5gD5t/Z5i74C5kIfVvbC', CAST(N'2025-12-14T12:53:45.070' AS DateTime))
GO
INSERT [dbo].[Users] ([Id], [Email], [Username], [PasswordHash], [CreatedAt]) VALUES (9, N'vanna@gmail.com', N'Leng Vanna', N'$2b$10$YdpNcaFGkei1WDXwxdRO7.defbbzPW6vG17AVa.vwq/UfIuy4MxMC', CAST(N'2025-12-14T12:56:48.730' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E4979A8961]    Script Date: 12/14/2025 1:09:32 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D105346A14FC0F]    Script Date: 12/14/2025 1:09:32 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[PasswordResets]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
