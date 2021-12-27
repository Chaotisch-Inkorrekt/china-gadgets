/*
 * Token tooling for rc3
 */

const rc3 = {
	storageKey: 'rc3-mincg-2022',
	badgeListTargetId: 'rc3-badge-list',
	badges: [
		{
			slug: 'gadgeteer',
			title: 'M! Gadgeteer',
			token: "\x41",
			requiredGadgets: 2,
		},
		{
			slug: 'gadgetionado',
			title: 'M! Gadgetionado',
			token: "\x42",
			requiredGadgets: 3,
		},
		{
			slug: 'gadgetista',
			title: 'M! Gadgetista',
			token: "\x43",
			requiredGadgets: 4,
		},
	],
	data: null,
	unlockedBadges: {},
	init: function () {
		const storageJson = window.localStorage.getItem(this.storageKey);
		if (storageJson === null) {
			this.data = {};
		} else {
			try {
				this.data = JSON.parse(storageJson);
			} catch (error) {
				this.data = {};
			}
		}
		this.save();
	},
	visitGadget: function (gadgetId) {
		this.data[gadgetId] = gadgetId;
		this.save();
		console.info('Visited gadget:', gadgetId);
		this.checkBadges();
		this.showBadges(this.badgeListTargetId);
	},
	checkBadges: function () {
		const gadgetCount = Object.entries(this.data).reduce((count, value) => count += (value[0] === value[1]) ? 1 : 0, 0);
		console.info('Current number of visited gadgets:', gadgetCount);
		this.unlockedBadges = this.badges.filter((badge) => (gadgetCount >= badge.requiredGadgets) && (console.info('Unlocked badge:', badge) || true));
	},
	showBadges: function (targetElementId) {
		const target = document.getElementById(targetElementId);

		if (!target || this.unlockedBadges.length < 1) { return false; }

		const badgeList = document.createElement('ul');

		this.unlockedBadges.forEach(badge => {
			const badgeItem = document.createElement('li');
			badgeItem.innerHTML = `<strong>${badge.title}</strong> (${badge.requiredGadgets} Gadget${(badge.requiredGadgets === 1) ? '' : 's'}): <input type="text" class="rc3-badge-token" value="${badge.token}" readonly="readonly" />`;
			badgeList.appendChild(badgeItem);
		});

		target.replaceChildren(badgeList);
	},
	save: function () {
		window.localStorage.setItem(this.storageKey, JSON.stringify(this.data));
	},
};
rc3.init();
