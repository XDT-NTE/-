# -*- coding: gbk -*-

# yuan = [
#     {"value":0,"name":"一"},
#     {"value":0,"name":"二"},
#     {"value":0,"name":"三"},
#     {"value":0,"name":"四"},
#     {"value":0,"name":"五"},
#     {"value":0,"name":"六"},
# ]



# 输入
# 1 2
# z = input()
# # TODO 把字符串以空格隔开（切片）
# # ["1", "2"]
# x = z.split(" ")
# num1 = int(x[0])
# num2 = int(x[1])
# print(num1 * num2)

# z,x = input().split(" ")
di = [{'id': 1, 'user': 'aaa', 'shop': '江职店', 'difficulty': '简单', 'instructor': 'PP教练', 'trainingTime': '2023-10-1 05:58:00', 'imgid': 1},
      {'id': 2, 'user': 'aaa', 'shop': '江职店', 'difficulty': '简单', 'instructor': 'PP教练', 'trainingTime': '2023-10-21 05:58:00', 'imgid': 2},
      {'id': 3, 'user': 'bbb', 'shop': '江职店', 'difficulty': '地狱', 'instructor':'细狗教练', 'trainingTime': '2023-10-21 01:00:00', 'imgid': 2},
      {'id': 4, 'user': 'sdf', 'shop': '江职店', 'difficulty': '简单', 'instructor': 'PP教练', 'trainingTime': '2023-10-29 10:19:00', 'imgid': 2},
      {'id': 5, 'user': 'ds', 'shop': '江职店', 'difficulty': '简单', 'instructor': 'PP教练', 'trainingTime': '2023-10-12 16:20:00', 'imgid': 2},
      {'id': 6, 'user': 'asd', 'shop': '江职店', 'difficulty': '简单', 'instructor': 'PP教练', 'trainingTime': '2023-10-31 13:54:00', 'imgid': 2}
]
new_list = sorted(di, key = lambda x:x["trainingTime"])
new_list = new_list[::-1]
for i in new_list:
    print(i)





