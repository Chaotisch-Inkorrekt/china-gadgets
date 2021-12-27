/*
 * Token tooling for rc3
 */

const rc3 = {
	storageKey: 'rc3-mincg-2022',
	badgeListTargetId: 'rc3-badge-list',
	badges: [
		{
			slug: 'gadgeteer',
			title: 'M!Gadgeteer',
			token: "\x68\x37\x31\x38\x70\x48\x57\x38\x59\x73\x74\x76\x47\x65\x7a\x34\x76\x78\x67\x62\x73\x66\x46\x74\x4f\x52\x36\x33\x4c\x41\x6f\x75\x4d\x73\x73\x78\x37\x73\x44\x4c\x62\x39\x4e\x52\x5a\x35\x6c\x70\x37\x4b",
			requiredGadgets: 5,
		},
		{
			slug: 'gadgetionado',
			title: 'M!Gadgetionado',
			token: "\x37\x33\x4c\x5a\x65\x48\x52\x54\x5a\x32\x6d\x48\x53\x71\x6c\x4b\x64\x66\x44\x49\x4e\x6e\x36\x52\x4d\x43\x47\x70\x62\x39\x7a\x75\x32\x78\x6d\x48\x62\x62\x69\x44\x62\x73\x36\x4c\x31\x33\x66\x67\x54\x4c",
			requiredGadgets: 15,
		},
		{
			slug: 'gadgetista',
			title: 'M!Gadgetista',
			token: "\x72\x61\x7a\x48\x46\x46\x4e\x33\x36\x65\x74\x78\x36\x76\x37\x66\x55\x31\x5a\x47\x49\x46\x4c\x75\x4d\x77\x53\x4d\x47\x4a\x4c\x6e\x6f\x65\x34\x42\x48\x61\x35\x55\x4f\x46\x52\x4b\x32\x75\x6f\x4e\x33\x6a",
			requiredGadgets: 30,
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
