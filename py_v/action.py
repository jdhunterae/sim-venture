from utils import *
from effect import *


class Action(object):

    def __init__(self, actor):
        self.actor = actor
        self.success_effect = NoEffect(self)
        self.failure_effect = NoEffect(self)

    def perform(self, target_options):
        targets = self.choose_targets(target_options)
        if self.attempt(targets):
            self.success_effect.cause(targets)
        else:
            self.failure_effect.cause(targets)

    def choose_targets(self, target_options):
        if type(target_options) is not type([]):
            target_options = [target_options]
        return target_options

    def attempt(self, targets):
        if Die(2).roll() is 1:
            return True
        else:
            return False


class AttackAction(Action):

    def __init__(self, actor):
        super(AttackAction, self).__init__(actor)
        self.success_effect = DamageEffect(self)
        self.failure_effect = MissEffect(self)

    def choose_targets(self, target_options):
        super(AttackAction, self).choose_targets(target_options)

        for member in target_options:
            if member is not self.actor:
                return [member]
        return None


class EscapeAction(action):

    def __init__(self, actor):
        super(EscapeAction, self).__init__(actor)
        self.success_effect = RunAwayEffect(self)
        self.failure_effect = BlockedEffect(self)


class MagicMissleAction(Action):

    def __init__(self, actor):
        super(MagicMissleAction, self).__init__(actor)
        self.success_effect = MagicDamageEffect(self)
        self.failure_effect = MagicMissEffect(self)

    def perform(self, target_options):
        super(MagicMissleAction, self).perform(target_options)
        self.actor.mana = max(0, self.actor.mana - 1)

    def attempt(self, targets):
        if self.actor.mana >= 1:
            return super(MagicMissleAction, self).attempt(targets)
        else:
            return False

    def choose_targets(self, target_options):
        super(MagicMissleAction, self).choose_targets(target_options)

        targets = list(target_options)
        targets.remove(self.actor)

        if targets:
            return targets
        return None
