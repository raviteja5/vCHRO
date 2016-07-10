import re

#set of traits
traits = ["trustworthy","neuroticism","conscientiousness","extrovertedness","agreeableness","coachable"]
vals=[0,0,0,0,0,0]  #default values for traits
success = 0     #initialize success

#Update the Ideal concept, after getting values for each employee
def update():
    diff = []
    for x in range(0, len(defs)):
            diff.append(defs[x] - vals[x])
    maxm = diff.index(max(diff))
    minm = diff.index(min (diff))
    if success >= 7:
        if defs[minm] <= 4.8 and defs[maxm] >= 0.2:
            defs[minm] += 0.2
            defs[maxm] -= 0.2
    if success <= 3:
        if defs[maxm] <= 4.8 and defs[minm] >= 0.2:
            defs[maxm] += 0.2
            defs[minm] -= 0.2
    write_to_file()

#Write the values to idealEmployeeConcept.txt
def write_to_file():
    f = open('idealEmployeeConcept','w')
    f.write("(idealEmployee ")
    f.write("(trust "+ str(defs[0]) + ") ")
    f.write("(neuro "+ str(defs[1]) + ") ")
    f.write("(consci "+ str(defs[2]) + ") ")
    f.write("(extro "+ str(defs[3]) + ") ")
    f.write("(agree "+ str(defs[4]) + ") ")
    f.write("(coach "+ str(defs[5]) + "))")
    print "Ideal employee concept updated with values:", defs


#Read the values to idealEmployeeConcept.txt
def read_from_file():
    global defs
    f = open('idealEmployeeConcept','r')
    line = f.readline()
    defs = map(float, re.findall("\d+\.\d+",line))

############################## Code starts execution here #######################################
yn = raw_input("Would you like to rate an employee after observation for 5 months (y/n)? ")
while yn == 'y':
    read_from_file()
    print("For all the following questions, 5.0 is best and 0.0 is poor:")
    # Read the value for each trait
    for t in traits:
        vals[traits.index(t)] = input("How would you rate "+ t +" after 5 months (0~5)? ")
    # Read the value for rating of employee
    success = raw_input("How would you rate the employee on the whole (0~5)? ")
    update()
    yn = raw_input("Would you like to rate another employee? ")

