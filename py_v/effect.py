class Effect(object):

    def __init__(self, action):
        self.action = action

    def cause(self, target):
        pass


class NoEffect(Effect):

    def __init__(self, action):
        super(NoEffect, self).__init__(action)

    def cause(self, target):
        print("[error] no effect declared for '%s'" %
              type(self.action).__name__)
