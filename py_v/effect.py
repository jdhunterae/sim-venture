class Effect(object):

    def __init__(self, action):
        self.action = action

    def cause(self, targets):
        pass


class NoEffect(Effect):

    def __init__(self, action):
        super(NoEffect, self).__init__(action)

    def cause(self, targets):
        print("[error] no effect declared for '%s'" %
              type(self.action).__name__)


class DamageEffect(Effect):

    def __init__(self, action):
        super(DamageEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None:
            for target in targets:
                target.health = max(0, target.health -
                                    self.action.actor.attack_p)
                print("%s attacks %s for %d damage..." % (
                    self.action.actor.name, target.name, self.action.actor.attack_p))
                print("    %s: %d/%d" %
                      (target.name, target.health, target.health_max))
            else:
                print("[error]: %s can't find anything to attack..." %
                      self.action.actor.name)


class MissEffect(Effect):

    def __init__(self, action):
        super(MissEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None:
            for target in targets:
                print("%s swings at %s...and misses" %
                      (self.action.actor.name, target.name))
            else:
                print("[error]: %s can't find anyone to miss..." %
                      (self.action.actor.name))


class RunAwayEffect(Effect):

    def __init__(self, action):
        super(RunAwayEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None and self.action.actor in targets:
            print("%s tries to run..." % (self.action.actor.name))
            targets.remove(self.action.actor)
            print("    %s has escaped the battle." % (self.action.actor.name))
        else:
            print("[error]: %s can't run away from nothing..." %
                  (self.action.actor.name))


class BlockedEffect(Effect):

    def __init__(self, action):
        super(BlockedEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None and self.action.actor in targets:
            print("%s tries to run...but can't escape" %
                  (self.action.actor.name))
        else:
            print("[error]: %s can't run away from nothing..." %
                  (self.action.actor.name))


class MagicDamageEffect(Effect):

    def __init__(self, action):
        super(MagicDamageEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None:
            for target in targets:
                target.health = max(0, target.health -
                                    self.action.actor.attack_m)
                print("%s launches a barrage of magical missles at %s for %d damage..." % (
                    self.action.actor.name, target.name, self.action.actor.attack_m))
                print("    %s: %d/%d" %
                      (target.name, target.health, target.health_max))
            else:
                print("[error]: %s can't find anyone to focus on..." %
                      (self.action.actor.name))


class MagicMissEffect(Effect):

    def __init__(self, action):
        super(MagicMissEffect, self).__init__(action)

    def cause(self, targets):
        if targets is not None:
            for target in targets:
                print("%s summons up energies...and they fizzle" %
                      (self.action.actor.name))
            else:
                print("[error]: %s can't find anyone to focus on..." %
                      (self.action.actor.name))
