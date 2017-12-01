
class CPU:

    def __init__(self):
        self.lines = []
        self.instructions = []
        self.registers = {}

    def load_file(self,file_path):
        with open(file_path,'r') as f:
            self.lines = f.read().splitlines()
        #for l in self.lines:
        #    self.instructions.append(l.split())
        self.instructions = [l.split() for l in self.lines]
        print self.instructions

    def eval(self, expression):
        if expression in self.registers.keys():
            return self.registers[expression]
        else:
            return int(expression)


    def run_file(self):
        line_num = 0
        self.registers = {"a":0, "b":0, "c":1, "d":0}
        while line_num < len(self.instructions):
            # print "a=%d b=%d c=%d d=%d" % [registers[key] for key in sorted(registers.keys())]
            #print self.registers
            inst = self.instructions[line_num]
            #print(self.instructions[line_num])
            did_jump = False
            if inst[0] =='cpy':
                #print "going to copy"
                if inst[1] in self.registers.keys():
                    self.registers[inst[2]] = self.registers[inst[1]]
                else:
                    self.registers[inst[2]] = int(inst[1])
            elif inst[0] == 'inc':
                #print "going to increment"
                self.registers[inst[1]] += 1
            elif inst[0] == 'dec':
                #print "going to decrement"
                self.registers[inst[1]] -= 1
            elif inst[0] == 'jnz':
                #print "going to jump maybe depending"
                value = self.eval(inst[1])
                if value != 0:
                    line_num += int(inst[2])
                    did_jump = True

            if not did_jump:
                line_num += 1
        print(self.registers)

simple_punchcard = CPU()
simple_punchcard.load_file("input.txt")
simple_punchcard.run_file()